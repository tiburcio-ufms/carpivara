import 'package:go_router/go_router.dart';

import '../../../models/ride.dart';
import '../../../models/user.dart';
import '../../../repositories/ride_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'review_view.dart';

class ReviewViewModel extends ReviewViewModelProtocol {
  int _selectedRating = 0;
  String _comment = '';
  final Ride? _ride;

  final RideRepositoryProtocol _rideRepository;
  final SessionManagerProtocol _sessionManager;
  ReviewViewModel({
    Ride? ride,
    required RideRepositoryProtocol rideRepository,
    required SessionManagerProtocol sessionManager,
  }) : _ride = ride,
       _rideRepository = rideRepository,
       _sessionManager = sessionManager;

  @override
  int get selectedRating => _selectedRating;

  @override
  String get comment => _comment;

  @override
  Ride? get ride => _ride;

  @override
  User? get otherUser {
    if (_ride == null) return null;
    final currentUser = _sessionManager.session?.user;
    if (currentUser == null) return null;

    final isDriver = _ride.driver?.id == currentUser.id;
    return isDriver ? _ride.passenger : _ride.driver;
  }

  @override
  bool get canSubmit => _selectedRating > 0 && _selectedRating <= 5;

  @override
  void selectRating(int rating) {
    if (rating < 1 || rating > 5) return;
    _selectedRating = rating;
    notifyListeners();
  }

  @override
  void updateComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  @override
  Future<void> submitReview() async {
    if (!canSubmit || _ride?.id == null) return;

    setIsLoading(true);
    final reviewData = {
      'rating': _selectedRating,
      if (_comment.isNotEmpty) 'comment': _comment,
    };

    final result = await _rideRepository.reviewRide(_ride!.id!.toString(), reviewData);
    setIsLoading(false);

    switch (result) {
      case Ok():
        context?.go('/shell');
      case Error(:final error):
        renderFailure?.call(error.toString());
    }
  }
}
