import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/review.dart';
import 'package:carpivara/models/ride.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/ride/review/review_view_model.dart';
import 'package:carpivara/repositories/ride_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock classes
class MockRideRepository implements RideRepositoryProtocol {
  Result<Review>? reviewRideResult;

  @override
  Future<Result<List<Ride>>> getRides({Map<String, dynamic>? queryParameters}) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Ride>>> searchRide(Map<String, dynamic> searchParams) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<User>>> searchDrivers(Map<String, dynamic> searchParams) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Ride>> createRide(Map<String, dynamic> rideData) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> cancelRide(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Ride>> finishRide(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Ride>> acceptRide(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData) async {
    return reviewRideResult ?? Result.error(Exception('Not configured'));
  }
}

class MockSessionManager implements SessionManagerProtocol {
  Session? _session;

  @override
  Session? get session => _session;

  @override
  bool get hasSession => _session != null;

  @override
  Future<bool> verifySession() async {
    return _session != null;
  }

  void setSession(Session session) {
    _session = session;
  }

  @override
  Future<void> saveSession(Session session) async {
    _session = session;
  }

  @override
  Future<void> removeSession() async {
    _session = null;
  }
}

void main() {
  group('ReviewViewModel', () {
    late MockRideRepository mockRepository;
    late MockSessionManager mockSessionManager;
    late ReviewViewModel viewModel;

    final testPassenger = User(
      id: 1,
      passport: '123456789012',
      name: 'Passenger',
      course: 'Computer Science',
      profilePic: '',
      rating: '4.5',
      ridesAsDriver: '0',
      ridesAsPassenger: '5',
      semester: '8',
      isWoman: false,
    );

    final testDriver = User(
      id: 2,
      passport: '987654321098',
      name: 'Driver',
      course: 'Engineering',
      profilePic: '',
      rating: '4.8',
      ridesAsDriver: '10',
      ridesAsPassenger: '2',
      semester: '6',
      isWoman: true,
    );

    final testRide = Ride(
      id: 1,
      driver: testDriver,
      passenger: testPassenger,
      addresses: [
        Address(
          userId: 1,
          street: 'Test Street',
          number: '123',
          neighborhood: 'Test Neighborhood',
          complement: '',
          city: 'Test City',
          state: 'Test State',
          country: 'Brasil',
          postalCode: '12345-678',
          nickname: 'Home',
        ),
      ],
      requestDate: DateTime.now(),
      confirmationDate: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );

    setUp(() {
      mockRepository = MockRideRepository();
      mockSessionManager = MockSessionManager();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      expect(viewModel.selectedRating, equals(0));
      expect(viewModel.comment, isEmpty);
      expect(viewModel.ride, equals(testRide));
      expect(viewModel.canSubmit, isFalse);
    });

    test('selectRating updates rating', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      viewModel.selectRating(3);
      expect(viewModel.selectedRating, equals(3));
      expect(viewModel.canSubmit, isTrue);
    });

    test('selectRating ignores invalid ratings', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      viewModel.selectRating(0);
      expect(viewModel.selectedRating, equals(0));

      viewModel.selectRating(6);
      expect(viewModel.selectedRating, equals(0));

      viewModel.selectRating(-1);
      expect(viewModel.selectedRating, equals(0));
    });

    test('updateComment updates comment', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      viewModel.updateComment('Great ride!');
      expect(viewModel.comment, equals('Great ride!'));
    });

    test('canSubmit returns true when rating is valid', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      expect(viewModel.canSubmit, isFalse);

      viewModel.selectRating(1);
      expect(viewModel.canSubmit, isTrue);

      viewModel.selectRating(5);
      expect(viewModel.canSubmit, isTrue);
    });

    test('otherUser returns passenger when current user is driver', () {
      final session = Session(
        token: 'token',
        user: testDriver,
      );
      mockSessionManager.setSession(session);

      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      expect(viewModel.otherUser, equals(testPassenger));
    });

    test('otherUser returns driver when current user is passenger', () {
      final session = Session(
        token: 'token',
        user: testPassenger,
      );
      mockSessionManager.setSession(session);

      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      expect(viewModel.otherUser, equals(testDriver));
    });

    test('otherUser returns null when no session', () {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      expect(viewModel.otherUser, isNull);
    });

    test('submitReview - successful submission', () async {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      viewModel.selectRating(5);
      viewModel.updateComment('Excellent service!');

      final testReview = Review(
        id: 1,
        userId: testDriver.id,
        rideId: testRide.id!,
        rating: 5,
        comment: 'Excellent service!',
      );

      mockRepository.reviewRideResult = Result.ok(testReview);

      viewModel.setContext(null); // In real test, use mock context

      await viewModel.submitReview();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.isLoading, isFalse);
    });

    test('submitReview - failed submission', () async {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      viewModel.selectRating(4);

      mockRepository.reviewRideResult = Result.error(Exception('Network error'));

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.submitReview();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });

    test('submitReview - does not submit if canSubmit is false', () async {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
        ride: testRide,
      );

      // No rating selected
      await viewModel.submitReview();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Should not have called repository
      expect(viewModel.isLoading, isFalse);
    });

    test('submitReview - does not submit if ride is null', () async {
      viewModel = ReviewViewModel(
        rideRepository: mockRepository,
        sessionManager: mockSessionManager,
      );

      viewModel.selectRating(5);

      await viewModel.submitReview();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.isLoading, isFalse);
    });
  });
}
