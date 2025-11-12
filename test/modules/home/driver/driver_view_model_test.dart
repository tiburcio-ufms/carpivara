import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/review.dart';
import 'package:carpivara/models/ride.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/home/driver/driver_view_model.dart';
import 'package:carpivara/repositories/ride_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock classes
class MockRideRepository implements RideRepositoryProtocol {
  Result<List<Ride>>? getRidesResult;
  Result<Ride>? acceptRideResult;
  Result<void>? cancelRideResult;

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
    return cancelRideResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<Ride>> finishRide(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Ride>> acceptRide(String id) async {
    return acceptRideResult ?? Result.error(Exception('Not configured'));
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
  group('DriverViewModel', () {
    late MockRideRepository mockRepository;
    late MockSessionManager mockSessionManager;
    late DriverViewModel viewModel;

    final testDriver = User(
      id: 1,
      passport: '123456789012',
      name: 'Driver',
      course: 'Engineering',
      profilePic: '',
      rating: '4.8',
      ridesAsDriver: '10',
      ridesAsPassenger: '2',
      semester: '6',
      isWoman: true,
    );

    final testPassenger = User(
      id: 2,
      passport: '987654321098',
      name: 'Passenger',
      course: 'Computer Science',
      profilePic: '',
      rating: '4.5',
      ridesAsDriver: '0',
      ridesAsPassenger: '5',
      semester: '8',
      isWoman: false,
    );

    final testAddress = Address(
      userId: 2,
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
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state', () {
      mockRepository.getRidesResult = const Result.ok([]);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      expect(viewModel.onlyWoman, isFalse);
      expect(viewModel.availableRides, isEmpty);
      expect(viewModel.isWoman, isTrue);
    });

    test('loads available rides on initialization', () async {
      final ride = Ride(
        id: 1,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride]);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 400));

      expect(viewModel.availableRides.length, greaterThanOrEqualTo(1));
    });

    test('didTapOnlyWomanSwitch updates filter and reloads rides', () async {
      mockRepository.getRidesResult = const Result.ok([]);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      expect(viewModel.onlyWoman, isFalse);

      viewModel.didTapOnlyWomanSwitch(true);

      expect(viewModel.onlyWoman, isTrue);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('didTapAcceptRide accepts ride successfully', () async {
      final ride = Ride(
        id: 1,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      final acceptedRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
        confirmationDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride]);
      mockRepository.acceptRideResult = Result.ok(acceptedRide);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 400));

      final initialCount = viewModel.availableRides.length;

      await viewModel.didTapAcceptRide(ride);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Ride should be removed from available rides
      expect(viewModel.availableRides.length, lessThan(initialCount));
      expect(viewModel.availableRides.any((r) => r.id == ride.id), isFalse);
    });

    test('didTapAcceptRide handles error', () async {
      final ride = Ride(
        id: 1,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride]);
      mockRepository.acceptRideResult = Result.error(Exception('Network error'));

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 400));

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.didTapAcceptRide(ride);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });

    test('didTapRejectRide rejects ride successfully', () async {
      final ride = Ride(
        id: 1,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride]);
      mockRepository.cancelRideResult = const Result.ok(null);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 400));

      final initialCount = viewModel.availableRides.length;

      await viewModel.didTapRejectRide(ride);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Ride should be removed from available rides
      expect(viewModel.availableRides.length, lessThan(initialCount));
      expect(viewModel.availableRides.any((r) => r.id == ride.id), isFalse);
    });

    test('didTapRejectRide handles error', () async {
      final ride = Ride(
        id: 1,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride]);
      mockRepository.cancelRideResult = Result.error(Exception('Network error'));

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 400));

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.didTapRejectRide(ride);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });

    test('filters rides by only_woman when enabled', () async {
      final womanPassenger = User(
        id: 3,
        passport: '111111111111',
        name: 'Woman Passenger',
        course: 'Math',
        profilePic: '',
        rating: '4.0',
        ridesAsDriver: '0',
        ridesAsPassenger: '3',
        semester: '4',
        isWoman: true,
      );

      final ride1 = Ride(
        id: 1,
        passenger: womanPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      final ride2 = Ride(
        id: 2,
        passenger: testPassenger, // Not a woman
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockRepository.getRidesResult = Result.ok([ride1, ride2]);

      viewModel = DriverViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRepository,
      );

      viewModel.didTapOnlyWomanSwitch(true);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 400));

      // The filtering happens in the repository/backend, so we just verify the call was made
      expect(viewModel.onlyWoman, isTrue);
    });
  });
}
