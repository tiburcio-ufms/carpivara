import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/review.dart';
import 'package:carpivara/models/ride.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/profile/history/history_view_model.dart';
import 'package:carpivara/repositories/ride_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock classes
class MockRideRepository implements RideRepositoryProtocol {
  Result<List<Ride>>? getRidesResult;

  @override
  Future<Result<List<Ride>>> getRides({Map<String, dynamic>? queryParameters}) async {
    return getRidesResult ?? Result.error(Exception('Not configured'));
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
    throw UnimplementedError();
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
  group('HistoryViewModel', () {
    late MockRideRepository mockRepository;
    late MockSessionManager mockSessionManager;
    late HistoryViewModel viewModel;

    final testUser = User(
      id: 1,
      passport: '123456789012',
      name: 'Test User',
      course: 'Computer Science',
      profilePic: '',
      rating: '4.5',
      ridesAsDriver: '10',
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

    final testAddress = Address(
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
    );

    setUp(() {
      mockRepository = MockRideRepository();
      mockSessionManager = MockSessionManager();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state - empty rides', () {
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);
      mockRepository.getRidesResult = const Result.ok([]);

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      expect(viewModel.rides, isEmpty);
    });

    test('loads rides for current user as passenger', () async {
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);

      final ride1 = Ride(
        id: 1,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 1)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 1)),
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      final ride2 = Ride(
        id: 2,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 2)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 2)),
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      mockRepository.getRidesResult = Result.ok([ride1, ride2]);

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.rides.length, equals(2));
      expect(viewModel.rides.first.id, equals(1)); // Most recent first
      expect(viewModel.rides.last.id, equals(2));
    });

    test('loads rides for current user as driver', () async {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      final passenger = User(
        id: 3,
        passport: '111111111111',
        name: 'Passenger',
        course: 'Math',
        profilePic: '',
        rating: '4.0',
        ridesAsDriver: '0',
        ridesAsPassenger: '3',
        semester: '4',
        isWoman: false,
      );

      final ride = Ride(
        id: 1,
        driver: testDriver,
        passenger: passenger,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 1)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 1)),
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      mockRepository.getRidesResult = Result.ok([ride]);

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.rides.length, equals(1));
      expect(viewModel.rides.first.driver?.id, equals(testDriver.id));
    });

    test('filters out rides not related to current user', () async {
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);

      final otherUser = User(
        id: 3,
        passport: '111111111111',
        name: 'Other User',
        course: 'Math',
        profilePic: '',
        rating: '4.0',
        ridesAsDriver: '0',
        ridesAsPassenger: '3',
        semester: '4',
        isWoman: false,
      );

      final userRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now(),
        confirmationDate: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      final otherRide = Ride(
        id: 2,
        driver: testDriver,
        passenger: otherUser,
        addresses: [testAddress],
        requestDate: DateTime.now(),
        confirmationDate: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([userRide, otherRide]);

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.rides.length, equals(1));
      expect(viewModel.rides.first.id, equals(1));
    });

    test('sorts rides by request date descending', () async {
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);

      final ride1 = Ride(
        id: 1,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 3)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 3)),
        startDate: DateTime.now().subtract(const Duration(days: 3)),
        endDate: DateTime.now().subtract(const Duration(days: 3)),
      );

      final ride2 = Ride(
        id: 2,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 1)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 1)),
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      final ride3 = Ride(
        id: 3,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(days: 2)),
        confirmationDate: DateTime.now().subtract(const Duration(days: 2)),
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      mockRepository.getRidesResult = Result.ok([ride1, ride2, ride3]);

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.rides.length, equals(3));
      expect(viewModel.rides[0].id, equals(2)); // Most recent
      expect(viewModel.rides[1].id, equals(3));
      expect(viewModel.rides[2].id, equals(1)); // Oldest
    });

    test('handles error when loading rides', () async {
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);
      mockRepository.getRidesResult = Result.error(Exception('Network error'));

      var failureCalled = false;
      String? failureMessage;

      viewModel = HistoryViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });
  });
}
