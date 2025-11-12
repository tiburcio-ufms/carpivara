import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/maps_route_data.dart';
import '../../../models/ride.dart';
import '../../../models/user.dart';
import '../../../repositories/places_repository.dart';
import '../../../repositories/ride_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'live_view.dart';

class LiveViewModel extends LiveViewModelProtocol {
  Ride? _currentRide;
  MapsRouteData? _route;
  GoogleMapController? _mapController;
  Timer? _rideStatusTimer;
  Timer? _locationUpdateTimer;
  StreamSubscription<Position>? _positionStream;
  bool _isDriver = false;
  LatLng? _currentUserLocation;
  bool _isNavigationMode = false;

  final SessionManagerProtocol _sessionManager;
  final RideRepositoryProtocol _rideRepository;
  final PlacesRepositoryProtocol _placesRepository;

  LiveViewModel({
    Ride? ride,
    required SessionManagerProtocol sessionManager,
    required RideRepositoryProtocol rideRepository,
    required PlacesRepositoryProtocol placesRepository,
  }) : _sessionManager = sessionManager,
       _rideRepository = rideRepository,
       _placesRepository = placesRepository {
    if (ride != null) {
      _initializeWithRide(ride);
    } else {
      _loadCurrentRide();
    }
  }

  @override
  Ride? get currentRide => _currentRide;

  @override
  MapsRouteData? get route => _route;

  @override
  bool get isDriver => _isDriver;

  @override
  LatLng? get destinationLatLng =>
      _currentRide?.addresses.first.latitude != null && _currentRide?.addresses.first.longitude != null
      ? LatLng(_currentRide!.addresses.first.latitude!, _currentRide!.addresses.first.longitude!)
      : null;

  @override
  LatLng? get currentUserLocation => _currentUserLocation;

  @override
  bool get isNavigationMode => _isNavigationMode;

  @override
  User? get otherUser {
    if (_currentRide == null) return null;
    return _isDriver ? _currentRide!.passenger : _currentRide!.driver;
  }

  @override
  String get destinationAddress {
    if (_currentRide == null || _currentRide!.addresses.isEmpty) return 'Destino não informado';
    return _currentRide!.addresses.first.street;
  }

  @override
  String? get rideStatus {
    if (_currentRide == null) return null;
    if (_currentRide!.endDate != null) return 'Finalizada';
    if (_currentRide!.startDate != null) return 'Em andamento';
    if (_currentRide!.confirmationDate != null) return 'Aguardando início';
    return 'Pendente';
  }

  @override
  void onMapReady(GoogleMapController controller) {
    _mapController = controller;
    if (_isNavigationMode && _currentUserLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentUserLocation!,
            zoom: 17,
            tilt: 45,
          ),
        ),
      );
    } else if (_route != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(_route!.bounds, 75));
    }
  }

  @override
  void toggleNavigationMode() {
    _isNavigationMode = !_isNavigationMode;
    notifyListeners();

    if (_isNavigationMode) {
      _startLocationTracking();
    } else {
      _stopLocationTracking();
      if (_route != null && _mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLngBounds(_route!.bounds, 75));
      }
    }
  }

  @override
  Future<void> finishRide() async {
    if (_currentRide?.id == null) return;

    setIsLoading(true);
    final result = await _rideRepository.finishRide(_currentRide!.id!.toString());
    setIsLoading(false);

    switch (result) {
      case Ok():
        _rideStatusTimer?.cancel();
        _currentRide = null;
        notifyListeners();
        context?.go('/shell');
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  @override
  Future<void> cancelRide() async {
    if (_currentRide?.id == null) return;

    setIsLoading(true);
    final result = await _rideRepository.cancelRide(_currentRide!.id!);
    setIsLoading(false);

    switch (result) {
      case Ok():
        _rideStatusTimer?.cancel();
        _currentRide = null;
        notifyListeners();
        context?.go('/shell');
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  @override
  void dispose() {
    _rideStatusTimer?.cancel();
    _locationUpdateTimer?.cancel();
    _positionStream?.cancel();
    super.dispose();
  }

  // Private methods -----------------------------------------------------------
  Future<void> _loadCurrentRide() async {
    final currentUser = _sessionManager.session?.user;
    if (currentUser == null) return;

    final result = await _rideRepository.getRides();
    switch (result) {
      case Ok(:final value):
        final activeRide = value.firstWhere(
          (ride) =>
              (ride.driverId == currentUser.id || ride.passengerId == currentUser.id) &&
              ride.confirmationDate != null &&
              ride.endDate == null,
          orElse: () => Ride(
            driverId: 0,
            addresses: [],
            requestDate: DateTime.now(),
          ),
        );

        if (activeRide.id != null) {
          _currentRide = activeRide;
          _isDriver = activeRide.driverId == currentUser.id;
          notifyListeners();
          await _loadRoute();
          _startRideStatusPolling();
          _startLocationTracking();
          _isNavigationMode = true;
          notifyListeners();
        } else {
          context?.go('/shell');
        }
      case Error():
        break;
    }
  }

  Future<void> _loadRoute() async {
    if (_currentRide == null || _currentRide!.addresses.isEmpty) return;

    final destinationAddress = _currentRide!.addresses.first;
    if (destinationAddress.latitude == null || destinationAddress.longitude == null) return;

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final origin = LatLng(position.latitude, position.longitude);
      final destination = LatLng(destinationAddress.latitude!, destinationAddress.longitude!);

      final result = await _placesRepository.getDirections(origin, destination);
      switch (result) {
        case Ok(:final value):
          _route = value;
          notifyListeners();
          if (_mapController != null) _mapController!.animateCamera(CameraUpdate.newLatLngBounds(value.bounds, 75));
        case Error():
          break;
      }
    } on Exception catch (_) {
      // Silently fail if location is not available
    }
  }

  void _startRideStatusPolling() {
    _rideStatusTimer?.cancel();
    _rideStatusTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final currentUser = _sessionManager.session?.user;
      if (currentUser == null || _currentRide?.id == null) {
        timer.cancel();
        return;
      }

      final result = await _rideRepository.getRides();
      switch (result) {
        case Ok(:final value):
          final updatedRide = value.firstWhere(
            (r) => r.id == _currentRide?.id,
            orElse: () => _currentRide!,
          );

          if (updatedRide.endDate != null) {
            timer.cancel();
            _currentRide = null;
            notifyListeners();
            context?.go('/shell');
          } else {
            _currentRide = updatedRide;
            notifyListeners();
          }
        case Error():
          break;
      }
    });
  }

  void _initializeWithRide(Ride ride) {
    final currentUser = _sessionManager.session?.user;
    if (currentUser == null) {
      context?.go('/shell');
      return;
    }

    _currentRide = ride;
    _isDriver = ride.driverId == currentUser.id;
    notifyListeners();
    _loadRoute();
    _startRideStatusPolling();
    _startLocationTracking();
    _isNavigationMode = true;
    notifyListeners();
  }

  void _startLocationTracking() {
    _positionStream?.cancel();

    const locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) {
        _currentUserLocation = LatLng(position.latitude, position.longitude);

        if (_isNavigationMode && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentUserLocation!,
                zoom: 17,
                tilt: 45,
                bearing: position.heading,
              ),
            ),
          );
        }

        _locationUpdateTimer?.cancel();
        _locationUpdateTimer = Timer(const Duration(seconds: 30), _updateRouteFromCurrentLocation);

        notifyListeners();
      },
      onError: (error) {
        // Silently handle location errors
      },
    );
  }

  void _stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _locationUpdateTimer?.cancel();
  }

  Future<void> _updateRouteFromCurrentLocation() async {
    if (_currentRide == null || _currentRide!.addresses.isEmpty) return;
    if (_currentUserLocation == null) return;

    final destinationAddress = _currentRide!.addresses.first;
    if (destinationAddress.latitude == null || destinationAddress.longitude == null) return;

    final destination = LatLng(destinationAddress.latitude!, destinationAddress.longitude!);

    final result = await _placesRepository.getDirections(_currentUserLocation!, destination);
    switch (result) {
      case Ok(:final value):
        _route = value;
        notifyListeners();
      case Error():
        break;
    }
  }
}
