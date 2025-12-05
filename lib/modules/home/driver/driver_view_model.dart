import 'dart:async';

import 'package:go_router/go_router.dart';

import '../../../models/ride.dart';
import '../../../repositories/ride_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'driver_view.dart';

class DriverViewModel extends DriverViewModelProtocol {
  bool _onlyWoman = false;
  List<Ride> _availableRides = [];
  Timer? _ridePollingTimer;

  final SessionManagerProtocol _sessionManager;
  final RideRepositoryProtocol _rideRepository;

  DriverViewModel({required SessionManagerProtocol sessionManager, required RideRepositoryProtocol rideRepository})
    : _sessionManager = sessionManager,
      _rideRepository = rideRepository {
    _startRidePolling();
  }

  @override
  bool get isWoman => _sessionManager.session?.user.isWoman ?? false;

  @override
  bool get onlyWoman => _onlyWoman;

  @override
  List<Ride> get availableRides => _availableRides;

  @override
  Future<void> didTapAcceptRide(Ride ride) async {
    if (ride.id == null) return;

    setIsLoading(true);
    final result = await _rideRepository.acceptRide(ride.id!.toString());
    setIsLoading(false);

    switch (result) {
      case Ok(:final value):
        _availableRides = _availableRides.where((r) => r.id != ride.id).toList();
        notifyListeners();
        unawaited(context?.push('/shell/live', extra: value));
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  @override
  Future<void> didTapRejectRide(Ride ride) async {
    if (ride.id == null) return;

    setIsLoading(true);
    final result = await _rideRepository.cancelRide(ride.id!);
    setIsLoading(false);

    switch (result) {
      case Ok():
        _availableRides = _availableRides.where((r) => r.id != ride.id).toList();
        notifyListeners();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }

  @override
  void didTapOnlyWomanSwitch(bool value) {
    _onlyWoman = value;
    notifyListeners();
    _loadAvailableRides();
  }

  @override
  void dispose() {
    _ridePollingTimer?.cancel();
    super.dispose();
  }

  // Private methods -----------------------------------------------------------
  void _startRidePolling() {
    _loadAvailableRides();
    _ridePollingTimer?.cancel();
    _ridePollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadAvailableRides();
    });
  }

  Future<void> _loadAvailableRides() async {
    final currentUser = _sessionManager.session?.user;
    if (currentUser == null) return;

    final queryParameters = <String, dynamic>{
      'driver_id': currentUser.id,
      if (_onlyWoman) 'only_woman': true,
    };

    final result = await _rideRepository.getRides(queryParameters: queryParameters);
    switch (result) {
      case Ok(:final value):
        _availableRides = value;
        notifyListeners();
      case Error():
        break;
    }
  }
}
