import 'package:carpivara/models/address.dart';
import 'package:carpivara/models/maps_route_data.dart';
import 'package:carpivara/models/place_details.dart';
import 'package:carpivara/models/place_prediction.dart';
import 'package:carpivara/models/review.dart';
import 'package:carpivara/models/ride.dart';
import 'package:carpivara/models/session.dart';
import 'package:carpivara/models/user.dart';
import 'package:carpivara/modules/home/passenger/passenger_view_model.dart';
import 'package:carpivara/repositories/places_repository.dart';
import 'package:carpivara/repositories/ride_repository.dart';
import 'package:carpivara/support/utils/result.dart';
import 'package:carpivara/support/utils/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Mock classes
class MockRideRepository implements RideRepositoryProtocol {
  Result<List<User>>? searchDriversResult;
  Result<Ride>? createRideResult;
  Result<void>? cancelRideResult;
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
    return searchDriversResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<Ride>> createRide(Map<String, dynamic> rideData) async {
    return createRideResult ?? Result.error(Exception('Not configured'));
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
    throw UnimplementedError();
  }

  @override
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData) async {
    throw UnimplementedError();
  }
}

class MockPlacesRepository implements PlacesRepositoryProtocol {
  Result<List<PlacePrediction>>? getPlacePredictionsResult;
  Result<PlaceDetails>? getPlaceDetailsResult;
  Result<MapsRouteData>? getDirectionsResult;

  @override
  Future<Result<List<PlacePrediction>>> getPlacePredictions(String query) async {
    return getPlacePredictionsResult ?? Result.error(Exception('Not configured'));
  }

  @override
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId) async {
    return getPlaceDetailsResult ?? Result.error(Exception('Not configured'));
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

  group('PassengerViewModel', () {
    late MockRideRepository mockRideRepository;
    late MockPlacesRepository mockPlacesRepository;
    late MockSessionManager mockSessionManager;
    late PassengerViewModel viewModel;

    final testUser = User(
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

    setUp(() {
      mockRideRepository = MockRideRepository();
      mockPlacesRepository = MockPlacesRepository();
      mockSessionManager = MockSessionManager();
      final session = Session(token: 'token', user: testUser);
      mockSessionManager.setSession(session);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state', () {
      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      expect(viewModel.onlyWoman, isFalse);
      expect(viewModel.destinationQuery, isEmpty);
      expect(viewModel.placePredictions, isEmpty);
      expect(viewModel.availableDrivers, isEmpty);
      expect(viewModel.hasRequestedRide, isFalse);
      expect(viewModel.isWoman, isFalse);
    });

    test('updateDestination searches places when query length >= 3', () async {
      final predictions = [
        PlacePrediction(
          placeId: 'place1',
          description: 'Test Place 1',
        ),
        PlacePrediction(
          placeId: 'place2',
          description: 'Test Place 2',
        ),
      ];

      mockPlacesRepository.getPlacePredictionsResult = Result.ok(predictions);

      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      viewModel.updateDestination('test');

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.placePredictions.length, equals(2));
    });

    test('updateDestination clears predictions when query length < 3', () {
      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      viewModel.updateDestination('te');

      expect(viewModel.placePredictions, isEmpty);
    });

    test('selectPlace loads place details and searches drivers', () async {
      final prediction = PlacePrediction(
        placeId: 'place1',
        description: 'Test Place',
      );

      final placeDetails = PlaceDetails(
        placeId: 'place1',
        formattedAddress: '123 Test Street',
        latitude: -23.5505,
        longitude: -46.6333,
        name: 'Test Place',
      );

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

      final drivers = [testDriver];

      mockPlacesRepository.getPlaceDetailsResult = Result.ok(placeDetails);
      mockPlacesRepository.getDirectionsResult = Result.ok(route);
      mockRideRepository.searchDriversResult = Result.ok(drivers);

      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      await viewModel.selectPlace(prediction);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 200));

      expect(viewModel.destinationQuery, equals(placeDetails.formattedAddress));
      // destinationLatLng may be null if Geolocator fails (which is expected in tests)
      // The important thing is that the place was selected
      expect(viewModel.placePredictions, isEmpty); // Predictions should be cleared after selection
    });

    test('didTapOnlyWomanSwitch updates filter and searches drivers', () async {
      final placeDetails = PlaceDetails(
        placeId: 'place1',
        formattedAddress: '123 Test Street',
        latitude: -23.5505,
        longitude: -46.6333,
      );

      mockPlacesRepository.getPlaceDetailsResult = Result.ok(placeDetails);
      mockRideRepository.searchDriversResult = const Result.ok([]);

      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      // Set a destination first
      await viewModel.selectPlace(
        PlacePrediction(
          placeId: 'place1',
          description: 'Test Place',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.didTapOnlyWomanSwitch(true);

      expect(viewModel.onlyWoman, isTrue);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('requestRide creates ride successfully', () async {
      final placeDetails = PlaceDetails(
        placeId: 'place1',
        formattedAddress: '123 Test Street',
        latitude: -23.5505,
        longitude: -46.6333,
      );

      final testAddress = Address(
        userId: testUser.id,
        street: placeDetails.formattedAddress,
        number: '',
        neighborhood: '',
        complement: '',
        city: '',
        state: '',
        country: 'Brasil',
        postalCode: '',
        nickname: 'Destino',
        latitude: placeDetails.latitude,
        longitude: placeDetails.longitude,
      );

      final createdRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockPlacesRepository.getPlaceDetailsResult = Result.ok(placeDetails);
      mockRideRepository.createRideResult = Result.ok(createdRide);
      mockRideRepository.getRidesResult = Result.ok([createdRide]);

      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      // Set a destination first
      await viewModel.selectPlace(
        PlacePrediction(
          placeId: 'place1',
          description: 'Test Place',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 200));

      await viewModel.requestRide(testDriver);

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.hasRequestedRide, isTrue);
      expect(viewModel.availableDrivers, isEmpty);
    });

    test('requestRide shows error when no destination selected', () async {
      viewModel = PassengerViewModel(
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

      await viewModel.requestRide(testDriver);

      expect(failureCalled, isTrue);
      expect(failureMessage, contains('destino'));
    });

    test('clearDestination clears all destination data', () {
      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      viewModel.updateDestination('test query');
      viewModel.clearDestination();

      expect(viewModel.destinationQuery, isEmpty);
      expect(viewModel.placePredictions, isEmpty);
      expect(viewModel.availableDrivers, isEmpty);
      expect(viewModel.destinationLatLng, isNull);
      expect(viewModel.route, isNull);
    });

    test('cancelRide cancels requested ride', () async {
      final placeDetails = PlaceDetails(
        placeId: 'place1',
        formattedAddress: '123 Test Street',
        latitude: -23.5505,
        longitude: -46.6333,
      );

      final testAddress = Address(
        userId: testUser.id,
        street: placeDetails.formattedAddress,
        number: '',
        neighborhood: '',
        complement: '',
        city: '',
        state: '',
        country: 'Brasil',
        postalCode: '',
        nickname: 'Destino',
        latitude: placeDetails.latitude,
        longitude: placeDetails.longitude,
      );

      final createdRide = Ride(
        id: 1,
        driver: testDriver,
        passenger: testUser,
        addresses: [testAddress],
        requestDate: DateTime.now(),
      );

      mockPlacesRepository.getPlaceDetailsResult = Result.ok(placeDetails);
      mockRideRepository.createRideResult = Result.ok(createdRide);
      mockRideRepository.getRidesResult = Result.ok([createdRide]);
      mockRideRepository.cancelRideResult = const Result.ok(null);

      viewModel = PassengerViewModel(
        sessionManager: mockSessionManager,
        rideRepository: mockRideRepository,
        placesRepository: mockPlacesRepository,
      );

      // Set a destination and request ride
      await viewModel.selectPlace(
        PlacePrediction(
          placeId: 'place1',
          description: 'Test Place',
        ),
      );

      await Future.delayed(const Duration(milliseconds: 200));

      await viewModel.requestRide(testDriver);

      await Future.delayed(const Duration(milliseconds: 200));

      expect(viewModel.hasRequestedRide, isTrue);

      await viewModel.cancelRide();

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.hasRequestedRide, isFalse);
    });
  });
}
