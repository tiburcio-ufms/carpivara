import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/maps_route_data.dart';
import 'package:carpivara/models/place_details.dart';
import 'package:carpivara/models/place_prediction.dart';
import 'package:carpivara/models/review.dart';
import 'package:carpivara/models/ride.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/ride/live/live_view_model.dart';
import 'package:carpivara/repositories/places_repository.dart';
import 'package:carpivara/repositories/ride_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Mock classes
class MockRideRepository implements RideRepositoryProtocol {
  Result<List<Ride>>? getRidesResult;
  Result<Ride>? finishRideResult;
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
    return finishRideResult ?? Result.error(Exception('Not configured'));
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

class MockPlacesRepository implements PlacesRepositoryProtocol {
  Result<MapsRouteData>? getDirectionsResult;

  @override
  Future<Result<List<PlacePrediction>>> getPlacePredictions(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<MapsRouteData>> getDirections(LatLng origin, LatLng destination) async {
    return getDirectionsResult ?? Result.error(Exception('Not configured'));
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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LiveViewModel', () {
    late MockRideRepository mockRideRepository;
    late MockPlacesRepository mockPlacesRepository;
    late MockSessionManager mockSessionManager;
    late LiveViewModel viewModel;

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
      street: '123 Test Street',
      number: '123',
      neighborhood: 'Test Neighborhood',
      complement: '',
      city: 'Test City',
      state: 'Test State',
      country: 'Brasil',
      postalCode: '12345-678',
      nickname: 'Home',
      latitude: -23.5505,
      longitude: -46.6333,
    );

    final testRide = Ride(
      id: 1,
      driver: testDriver,
      passenger: testPassenger,
      addresses: [testAddress],
      requestDate: DateTime.now().subtract(const Duration(hours: 1)),
      confirmationDate: DateTime.now().subtract(const Duration(minutes: 30)),
      startDate: DateTime.now().subtract(const Duration(minutes: 15)),
    );

    setUp(() {
      mockRideRepository = MockRideRepository();
      mockPlacesRepository = MockPlacesRepository();
      mockSessionManager = MockSessionManager();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state with ride', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      final route = MapsRouteData(
        points: [
          const LatLng(-23.5505, -46.6333),
          const LatLng(-23.5515, -46.6343),
        ],
        bounds: LatLngBounds(
          southwest: const LatLng(-23.5525, -46.6353),
          northeast: const LatLng(-23.5495, -46.6323),
        ),
      );

      mockPlacesRepository.getDirectionsResult = Result.ok(route);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.currentRide, equals(testRide));
      expect(viewModel.isDriver, isTrue);
      expect(viewModel.destinationAddress, equals(testAddress.street));
    });

    test('isDriver returns true when current user is driver', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.isDriver, isTrue);
    });

    test('isDriver returns false when current user is passenger', () {
      final session = Session(token: 'token', user: testPassenger);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.isDriver, isFalse);
    });

    test('otherUser returns passenger when current user is driver', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.otherUser, equals(testPassenger));
    });

    test('otherUser returns driver when current user is passenger', () {
      final session = Session(token: 'token', user: testPassenger);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.otherUser, equals(testDriver));
    });

    test('destinationLatLng returns correct coordinates', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.destinationLatLng, isNotNull);
      expect(viewModel.destinationLatLng!.latitude, equals(testAddress.latitude));
      expect(viewModel.destinationLatLng!.longitude, equals(testAddress.longitude));
    });

    test('rideStatus returns correct status', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.rideStatus, equals('Em andamento'));
    });

    test('rideStatus returns "Finalizada" when endDate is set', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      final finishedRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(hours: 2)),
        confirmationDate: DateTime.now().subtract(const Duration(hours: 1)),
        startDate: DateTime.now().subtract(const Duration(minutes: 45)),
        endDate: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      viewModel = LiveViewModel(
        ride: finishedRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.rideStatus, equals('Finalizada'));
    });

    test('toggleNavigationMode toggles navigation mode', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.isNavigationMode, isTrue); // Starts in navigation mode

      viewModel.toggleNavigationMode();
      expect(viewModel.isNavigationMode, isFalse);

      viewModel.toggleNavigationMode();
      expect(viewModel.isNavigationMode, isTrue);
    });

    test('finishRide finishes ride successfully', () async {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      final finishedRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testPassenger,
        addresses: [testAddress],
        requestDate: DateTime.now().subtract(const Duration(hours: 1)),
        confirmationDate: DateTime.now().subtract(const Duration(minutes: 30)),
        startDate: DateTime.now().subtract(const Duration(minutes: 15)),
        endDate: DateTime.now(),
      );

      mockRideRepository.finishRideResult = Result.ok(finishedRide);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      await viewModel.finishRide();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.currentRide, isNull);
    });

    test('finishRide handles error', () async {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      mockRideRepository.finishRideResult = Result.error(Exception('Network error'));

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.finishRide();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });

    test('cancelRide cancels ride successfully', () async {
      final session = Session(token: 'token', user: testPassenger);
      mockSessionManager.setSession(session);

      mockRideRepository.cancelRideResult = const Result.ok(null);

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      await viewModel.cancelRide();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.currentRide, isNull);
    });

    test('cancelRide handles error', () async {
      final session = Session(token: 'token', user: testPassenger);
      mockSessionManager.setSession(session);

      mockRideRepository.cancelRideResult = Result.error(Exception('Network error'));

      viewModel = LiveViewModel(
        ride: testRide,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      var failureCalled = false;
      String? failureMessage;
      viewModel.setRenderFailure((message) {
        failureCalled = true;
        failureMessage = message;
      });

      await viewModel.cancelRide();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('Network error'));
    });

    test('destinationAddress returns default when no addresses', () {
      final session = Session(token: 'token', user: testDriver);
      mockSessionManager.setSession(session);

      final rideWithoutAddresses = Ride(
        id: 1,
        driver: testDriver,
        passenger: testPassenger,
        addresses: [],
        requestDate: DateTime.now(),
      );

      viewModel = LiveViewModel(
        ride: rideWithoutAddresses,
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.destinationAddress, equals('Destino não informado'));
    });
  });
}
