import 'dart:async';

import '../../models/address.dart';
import '../../models/review.dart';
import '../../models/ride.dart';
import '../../models/user.dart';
import '../../support/utils/result.dart';
import '../ride_repository.dart';

class RideRepositoryMock implements RideRepositoryProtocol {
  // Dados mockados de passageiros
  Map<int, User> _getPassengerData() {
    return {
      4: User(
        id: 4,
        passport: '2021004567',
        name: 'Pedro Oliveira',
        course: 'Administração',
        profilePic: '',
        rating: '4.6',
        ridesAsDriver: '5',
        ridesAsPassenger: '28',
        semester: '5º',
        isWoman: false,
      ),
      5: User(
        id: 5,
        passport: '2021005678',
        name: 'Juliana Ferreira',
        course: 'Psicologia',
        profilePic: '',
        rating: '4.9',
        ridesAsDriver: '12',
        ridesAsPassenger: '45',
        semester: '3º',
        isWoman: true,
      ),
      6: User(
        id: 6,
        passport: '2021006789',
        name: 'Carlos Mendes',
        course: 'Engenharia Civil',
        profilePic: '',
        rating: '4.5',
        ridesAsDriver: '8',
        ridesAsPassenger: '19',
        semester: '7º',
        isWoman: false,
      ),
    };
  }

  List<Ride> _getRides() {
    final passengerData = _getPassengerData();
    final driverData = _getDriverData();
    return [
      Ride(
        id: 1,
        driverId: 1,
        driver: driverData[1] != null
            ? User(
                id: 1,
                passport: driverData[1]!['passport'] as String,
                name: driverData[1]!['name'] as String,
                course: driverData[1]!['course'] as String,
                profilePic: '',
                rating: driverData[1]!['rating'] as String,
                ridesAsDriver: driverData[1]!['ridesAsDriver'] as String,
                ridesAsPassenger: driverData[1]!['ridesAsPassenger'] as String,
                semester: driverData[1]!['semester'] as String,
                isWoman: driverData[1]!['isWoman'] as bool,
                carModel: driverData[1]!['carModel'] as String,
                carPlate: driverData[1]!['carPlate'] as String,
              )
            : null,
        addresses: [
          Address(
            userId: 1,
            street: 'Rua das Flores',
            number: '123',
            neighborhood: 'Centro',
            complement: 'Apto 101',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01234-567',
            nickname: 'Casa',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
          Address(
            userId: 1,
            street: 'Avenida Paulista',
            number: '1000',
            neighborhood: 'Bela Vista',
            complement: '',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01310-100',
            nickname: 'Trabalho',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
        ],
        requestDate: DateTime.now().subtract(const Duration(hours: 2)),
        passenger: passengerData[4], // Pedro Oliveira solicitou esta corrida
        passengerId: 4,
      ),
      Ride(
        id: 2,
        driverId: 2,
        driver: driverData[2] != null
            ? User(
                id: 2,
                passport: driverData[2]!['passport'] as String,
                name: driverData[2]!['name'] as String,
                course: driverData[2]!['course'] as String,
                profilePic: '',
                rating: driverData[2]!['rating'] as String,
                ridesAsDriver: driverData[2]!['ridesAsDriver'] as String,
                ridesAsPassenger: driverData[2]!['ridesAsPassenger'] as String,
                semester: driverData[2]!['semester'] as String,
                isWoman: driverData[2]!['isWoman'] as bool,
                carModel: driverData[2]!['carModel'] as String,
                carPlate: driverData[2]!['carPlate'] as String,
              )
            : null,
        passengerId: 1,
        passenger: passengerData[5], // Juliana Ferreira
        addresses: [
          Address(
            userId: 2,
            street: 'Rua Augusta',
            number: '500',
            neighborhood: 'Consolação',
            complement: 'Sala 205',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01305-000',
            nickname: 'Casa',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
          Address(
            userId: 2,
            street: 'Rua Haddock Lobo',
            number: '800',
            neighborhood: 'Cerqueira César',
            complement: '',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01414-000',
            nickname: 'Trabalho',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
        ],
        requestDate: DateTime.now().subtract(const Duration(hours: 5)),
        confirmationDate: DateTime.now().subtract(const Duration(hours: 4)),
        startDate: DateTime.now().subtract(const Duration(hours: 3)),
        endDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Ride(
        id: 3,
        driverId: 3,
        driver: driverData[3] != null
            ? User(
                id: 3,
                passport: driverData[3]!['passport'] as String,
                name: driverData[3]!['name'] as String,
                course: driverData[3]!['course'] as String,
                profilePic: '',
                rating: driverData[3]!['rating'] as String,
                ridesAsDriver: driverData[3]!['ridesAsDriver'] as String,
                ridesAsPassenger: driverData[3]!['ridesAsPassenger'] as String,
                semester: driverData[3]!['semester'] as String,
                isWoman: driverData[3]!['isWoman'] as bool,
                carModel: driverData[3]!['carModel'] as String,
                carPlate: driverData[3]!['carPlate'] as String,
              )
            : null,
        addresses: [
          Address(
            userId: 3,
            street: 'Avenida Faria Lima',
            number: '2000',
            neighborhood: 'Itaim Bibi',
            complement: '',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01452-000',
            nickname: 'Casa',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
          Address(
            userId: 3,
            street: 'Rua Oscar Freire',
            number: '100',
            neighborhood: 'Jardins',
            complement: '',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '01426-001',
            nickname: 'Trabalho',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
        ],
        requestDate: DateTime.now().subtract(const Duration(minutes: 30)),
        passenger: passengerData[6], // Carlos Mendes solicitou esta corrida
        passengerId: 6,
      ),
      Ride(
        id: 4,
        driverId: 1,
        driver: driverData[1] != null
            ? User(
                id: 1,
                passport: driverData[1]!['passport'] as String,
                name: driverData[1]!['name'] as String,
                course: driverData[1]!['course'] as String,
                profilePic: '',
                rating: driverData[1]!['rating'] as String,
                ridesAsDriver: driverData[1]!['ridesAsDriver'] as String,
                ridesAsPassenger: driverData[1]!['ridesAsPassenger'] as String,
                semester: driverData[1]!['semester'] as String,
                isWoman: driverData[1]!['isWoman'] as bool,
                carModel: driverData[1]!['carModel'] as String,
                carPlate: driverData[1]!['carPlate'] as String,
              )
            : null,
        addresses: [
          Address(
            userId: 5,
            street: 'Rua dos Estudantes',
            number: '200',
            neighborhood: 'Cidade Universitária',
            complement: '',
            city: 'São Paulo',
            state: 'SP',
            country: 'Brasil',
            postalCode: '05508-000',
            nickname: 'Destino',
            latitude: -20.4829236,
            longitude: -54.6193833,
          ),
        ],
        requestDate: DateTime.now().subtract(const Duration(minutes: 10)),
        passenger: passengerData[5], // Juliana Ferreira solicitou esta corrida
        passengerId: 5,
      ),
    ];
  }

  final List<Ride> _rides = [];

  RideRepositoryMock() {
    _rides.addAll(_getRides());
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 700));
  }

  @override
  Future<Result<List<Ride>>> getRides({Map<String, dynamic>? queryParameters}) async {
    await _simulateNetworkDelay();

    var filteredRides = List<Ride>.from(_rides);

    // Filtrar por driver_id se fornecido
    if (queryParameters?['driver_id'] != null) {
      final driverId = queryParameters!['driver_id'] as int;
      filteredRides = filteredRides.where((ride) => ride.driverId == driverId).toList();
    }

    // Filtrar por only_woman se fornecido
    if (queryParameters?['only_woman'] == true) {
      filteredRides = filteredRides.where((ride) => ride.passenger?.isWoman ?? false).toList();
    }

    return Result.ok(filteredRides);
  }

  @override
  Future<Result<List<Ride>>> searchRide(Map<String, dynamic> searchParams) async {
    await _simulateNetworkDelay();

    final origin = searchParams['origin'] as String?;
    final destination = searchParams['destination'] as String?;

    if (origin == null && destination == null) {
      final availableRides = _rides.where((ride) => ride.passengerId == null).toList();
      return Result.ok(availableRides);
    }

    final filteredRides = _rides.where((ride) => ride.passengerId == null).toList();

    return Result.ok(filteredRides);
  }

  // Dados mockados realistas para os motoristas
  Map<int, Map<String, dynamic>> _getDriverData() {
    return {
      1: {
        'name': 'João Silva',
        'passport': '2021001234',
        'course': 'Engenharia de Computação',
        'rating': '4.8',
        'ridesAsDriver': '47',
        'ridesAsPassenger': '12',
        'semester': '8º',
        'isWoman': false,
        'carModel': 'Honda Civic',
        'carPlate': 'ABC-1234',
      },
      2: {
        'name': 'Maria Santos',
        'passport': '2021002345',
        'course': 'Medicina',
        'rating': '4.9',
        'ridesAsDriver': '89',
        'ridesAsPassenger': '23',
        'semester': '6º',
        'isWoman': true,
        'carModel': 'Toyota Corolla',
        'carPlate': 'DEF-5678',
      },
      3: {
        'name': 'Ana Costa',
        'passport': '2021003456',
        'course': 'Direito',
        'rating': '4.7',
        'ridesAsDriver': '32',
        'ridesAsPassenger': '8',
        'semester': '4º',
        'isWoman': true,
        'carModel': 'Volkswagen Gol',
        'carPlate': 'GHI-9012',
      },
    };
  }

  @override
  Future<Result<List<User>>> searchDrivers(Map<String, dynamic> searchParams) async {
    await _simulateNetworkDelay();

    final onlyWoman = searchParams['only_woman'] as bool? ?? false;
    final driverData = _getDriverData();

    // Mock de motoristas disponíveis baseados nos driverIds das corridas sem passageiro
    final availableDriverIds = _rides
        .where((ride) => ride.passengerId == null)
        .map((ride) => ride.driverId)
        .toSet()
        .toList();

    final mockDrivers = availableDriverIds
        .map((driverId) {
          final data = driverData[driverId];
          if (data == null) return null;

          final isWoman = data['isWoman'] as bool;

          // Filtrar por only_woman se necessário
          if (onlyWoman && !isWoman) return null;

          return User(
            id: driverId,
            passport: data['passport'] as String,
            name: data['name'] as String,
            course: data['course'] as String,
            profilePic: '',
            rating: data['rating'] as String,
            ridesAsDriver: data['ridesAsDriver'] as String,
            ridesAsPassenger: data['ridesAsPassenger'] as String,
            semester: data['semester'] as String,
            isWoman: isWoman,
            carModel: data['carModel'] as String,
            carPlate: data['carPlate'] as String,
          );
        })
        .whereType<User>()
        .toList();

    return Result.ok(mockDrivers);
  }

  @override
  Future<Result<Ride>> createRide(Map<String, dynamic> rideData) async {
    await _simulateNetworkDelay();

    final driverId = rideData['driver_id'] as int;
    final addressesData = rideData['addresses'] as List<dynamic>;
    final addresses = addressesData.map((json) => Address.fromJson(json as Map<String, dynamic>)).toList();

    final newRide = Ride(
      id: _rides.length + 1,
      driverId: driverId,
      addresses: addresses,
      requestDate: DateTime.now(),
    );

    _rides.add(newRide);
    return Result.ok(newRide);
  }

  @override
  Future<Result<void>> cancelRide(int id) async {
    await _simulateNetworkDelay();

    final rideIndex = _rides.indexWhere((ride) => ride.id == id);
    if (rideIndex == -1) return Result.error(Exception('Corrida não encontrada'));

    _rides.removeAt(rideIndex);
    return const Result.ok(null);
  }

  @override
  Future<Result<Ride>> acceptRide(String id) async {
    await _simulateNetworkDelay();

    final rideIndex = _rides.indexWhere((ride) => ride.id.toString() == id);

    if (rideIndex == -1) {
      return Result.error(Exception('Corrida não encontrada'));
    }

    final ride = _rides[rideIndex];
    final driverData = _getDriverData();
    final driver = driverData[ride.driverId];
    final acceptedRide = Ride(
      id: ride.id,
      driverId: ride.driverId,
      driver: driver != null
          ? User(
              id: ride.driverId,
              passport: driver['passport'] as String,
              name: driver['name'] as String,
              course: driver['course'] as String,
              profilePic: '',
              rating: driver['rating'] as String,
              ridesAsDriver: driver['ridesAsDriver'] as String,
              ridesAsPassenger: driver['ridesAsPassenger'] as String,
              semester: driver['semester'] as String,
              isWoman: driver['isWoman'] as bool,
              carModel: driver['carModel'] as String,
              carPlate: driver['carPlate'] as String,
            )
          : null,
      passengerId: ride.passengerId ?? 1,
      passenger: ride.passenger,
      addresses: ride.addresses,
      requestDate: ride.requestDate,
      confirmationDate: DateTime.now(),
    );

    _rides[rideIndex] = acceptedRide;

    return Result.ok(acceptedRide);
  }

  @override
  Future<Result<Ride>> finishRide(String id) async {
    await _simulateNetworkDelay();

    final rideIndex = _rides.indexWhere((ride) => ride.id.toString() == id);

    if (rideIndex == -1) {
      return Result.error(Exception('Corrida não encontrada'));
    }

    final ride = _rides[rideIndex];
    final finishedRide = Ride(
      id: ride.id,
      driverId: ride.driverId,
      driver: ride.driver,
      passengerId: ride.passengerId,
      passenger: ride.passenger,
      addresses: ride.addresses,
      requestDate: ride.requestDate,
      confirmationDate: ride.confirmationDate,
      startDate: ride.startDate ?? DateTime.now(),
      endDate: DateTime.now(),
    );

    _rides[rideIndex] = finishedRide;

    return Result.ok(finishedRide);
  }

  @override
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData) async {
    await _simulateNetworkDelay();

    final ride = _rides.firstWhere(
      (ride) => ride.id.toString() == id,
      orElse: () => throw Exception('Corrida não encontrada'),
    );

    final rating = reviewData['rating'] as int?;
    if (rating == null || rating < 1 || rating > 5) {
      return Result.error(Exception('Avaliação deve ser entre 1 e 5'));
    }

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1,
      rideId: ride.id!,
      rating: rating,
      comment: reviewData['comment'] as String?,
    );

    return Result.ok(review);
  }
}
