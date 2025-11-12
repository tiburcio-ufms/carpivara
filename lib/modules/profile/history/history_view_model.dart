import '../../../models/ride.dart';
import '../../../repositories/ride_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'history_view.dart';

class HistoryViewModel extends HistoryViewModelProtocol {
  List<Ride> _rides = [];
  final SessionManagerProtocol _sessionManager;
  final RideRepositoryProtocol _rideRepository;

  HistoryViewModel({
    required SessionManagerProtocol sessionManager,
    required RideRepositoryProtocol rideRepository,
  })  : _sessionManager = sessionManager,
        _rideRepository = rideRepository {
    _loadRides();
  }

  @override
  List<Ride> get rides => _rides;

  Future<void> _loadRides() async {
    setIsLoading(true);
    final result = await _rideRepository.getRides();
    switch (result) {
      case Ok(:final value):
        final user = _sessionManager.session!.user;
        _rides = value.where((ride) => ride.driverId == user.id || ride.passengerId == user.id).toList();
        _rides.sort((a, b) => b.requestDate.compareTo(a.requestDate));
        notifyListeners();
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
    setIsLoading(false);
  }
}
