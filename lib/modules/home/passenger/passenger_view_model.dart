import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/address.dart';
import '../../../models/maps_route_data.dart';
import '../../../models/place_details.dart';
import '../../../models/place_prediction.dart';
import '../../../models/ride.dart';
import '../../../models/user.dart';
import '../../../repositories/places_repository.dart';
import '../../../repositories/ride_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'passenger_view.dart';

class PassengerViewModel extends PassengerViewModelProtocol {
  bool _onlyWoman = false;
  String _destinationQuery = '';
  List<PlacePrediction> _placePredictions = [];
  PlaceDetails? _selectedDestination;
  List<User> _availableDrivers = [];
  Ride? _requestedRide;
  Timer? _rideStatusTimer;
  LatLng? _destinationLatLng;
  MapsRouteData? _route;
  GoogleMapController? _mapController;

  final RideRepositoryProtocol _rideRepository;
  final SessionManagerProtocol _sessionManager;
  final PlacesRepositoryProtocol _placesRepository;
  PassengerViewModel({
    required SessionManagerProtocol sessionManager,
    required RideRepositoryProtocol rideRepository,
    required PlacesRepositoryProtocol placesRepository,
  }) : _rideRepository = rideRepository,
       _sessionManager = sessionManager,
       _placesRepository = placesRepository;

  @override
  bool get isWoman => _sessionManager.session?.user.isWoman ?? false;

  @override
  bool get onlyWoman => _onlyWoman;

  @override
  String get destinationQuery => _destinationQuery;

  @override
  List<PlacePrediction> get placePredictions => _placePredictions;

  @override
  List<User> get availableDrivers => _availableDrivers;

  @override
  LatLng? get destinationLatLng => _destinationLatLng;

  @override
  MapsRouteData? get route => _route;

  @override
  bool get hasRequestedRide => _requestedRide != null;

  @override
  void updateDestination(String destination) {
    _destinationQuery = destination;
    _searchPlaces(destination);
  }

  @override
  void onMapReady(GoogleMapController controller) {
    _mapController = controller;
    _updateCameraIfNeeded();
  }

  void _updateCameraIfNeeded() {
    if (_mapController == null || _route == null) return;
    try {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(_route!.bounds, 75));
    } on Exception catch (_) {
      // Controller foi descartado, ignorar
      _mapController = null;
    }
  }

  @override
  Future<void> selectPlace(PlacePrediction prediction) async {
    setIsLoading(true);
    final result = await _placesRepository.getPlaceDetails(prediction.placeId);
    switch (result) {
      case Ok(:final value):
        _placePredictions = [];
        _selectedDestination = value;
        _destinationQuery = value.formattedAddress;
        _destinationLatLng = LatLng(value.latitude, value.longitude);
        await _loadRoute();
        await _searchDrivers();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
    setIsLoading(false);
  }

  @override
  void didTapOnlyWomanSwitch(bool value) {
    _onlyWoman = value;
    notifyListeners();
    if (_selectedDestination != null) _searchDrivers();
  }

  @override
  Future<void> requestRide(User driver) async {
    if (_selectedDestination == null) {
      renderFailure?.call('Selecione um destino primeiro');
      return;
    }

    setIsLoading(true);
    final user = _sessionManager.session?.user;
    if (user == null) {
      setIsLoading(false);
      renderFailure?.call('Usuário não autenticado');
      return;
    }

    // Criar endereço de destino
    final destinationAddress = Address(
      userId: user.id,
      street: _selectedDestination!.formattedAddress,
      number: '',
      neighborhood: '',
      complement: '',
      city: '',
      state: '',
      country: 'Brasil',
      postalCode: '',
      nickname: 'Destino',
      latitude: _selectedDestination!.latitude,
      longitude: _selectedDestination!.longitude,
    );

    final rideData = {
      'driver_id': driver.id,
      'addresses': [destinationAddress.toJson()],
    };

    final result = await _rideRepository.createRide(rideData);
    setIsLoading(false);

    switch (result) {
      case Ok(:final value):
        _requestedRide = value;
        _availableDrivers = [];
        notifyListeners();
        _startRideStatusPolling();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  @override
  void clearDestination() {
    _destinationQuery = '';
    _selectedDestination = null;
    _placePredictions = [];
    _availableDrivers = [];
    _destinationLatLng = null;
    _route = null;
    notifyListeners();
  }

  @override
  Future<void> cancelRide() async {
    if (_requestedRide?.id == null) return;

    setIsLoading(true);
    final result = await _rideRepository.cancelRide(_requestedRide!.id!);
    switch (result) {
      case Ok():
        _rideStatusTimer?.cancel();
        _requestedRide = null;
        notifyListeners();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
    setIsLoading(false);
  }

  @override
  void dispose() {
    _rideStatusTimer?.cancel();
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  // Private methods -----------------------------------------------------------
  Future<void> _loadRoute() async {
    if (_selectedDestination == null) return;

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final origin = LatLng(position.latitude, position.longitude);

      final destination = LatLng(_selectedDestination!.latitude, _selectedDestination!.longitude);

      final result = await _placesRepository.getDirections(origin, destination);
      switch (result) {
        case Ok(:final value):
          _route = value;
          notifyListeners();
          _updateCameraIfNeeded();
        case Error():
          break;
      }
    } on Exception catch (_) {
      // Silently fail if location is not available
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.length < 3) {
      _placePredictions = [];
      notifyListeners();
      return;
    }

    final result = await _placesRepository.getPlacePredictions(query);
    switch (result) {
      case Ok(:final value):
        _placePredictions = value;
        notifyListeners();
      case Error():
        _placePredictions = [];
        notifyListeners();
    }
  }

  Future<void> _searchDrivers() async {
    if (_selectedDestination == null) return;
    setIsLoading(true);
    LatLng? currentLocation;
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = LatLng(position.latitude, position.longitude);
    } on Exception catch (_) {
      // Continue without current location
    }
    final searchParams = {
      if (currentLocation != null) 'origin_lat': currentLocation.latitude,
      if (currentLocation != null) 'origin_lng': currentLocation.longitude,
      'only_woman': _onlyWoman,
      'destination_lat': _selectedDestination!.latitude,
      'destination_lng': _selectedDestination!.longitude,
    };
    final result = await _rideRepository.searchDrivers(searchParams);
    switch (result) {
      case Ok(:final value):
        _availableDrivers = value;
        notifyListeners();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
    setIsLoading(false);
  }

  void _startRideStatusPolling() {
    _rideStatusTimer?.cancel();
    _rideStatusTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_requestedRide?.id == null) return timer.cancel();

      final result = await _rideRepository.getRides();
      switch (result) {
        case Ok(:final value):
          final updatedRide = value.firstWhere((r) => r.id == _requestedRide?.id, orElse: () => _requestedRide!);

          if (updatedRide.confirmationDate != null) {
            timer.cancel();
            final rideToPass = updatedRide;
            _requestedRide = null;
            unawaited(context?.push('/shell/live', extra: rideToPass));
          } else if (updatedRide.endDate != null) {
            timer.cancel();
            _requestedRide = null;
            notifyListeners();
          }
        case Error():
          break;
      }
    });
  }
}
