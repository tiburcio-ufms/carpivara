import '../models/review.dart';
import '../models/ride.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class RideRepositoryProtocol {
  Future<Result<List<Ride>>> getRides({Map<String, dynamic>? queryParameters});
  Future<Result<List<Ride>>> searchRide(Map<String, dynamic> searchParams);
  Future<Result<List<User>>> searchDrivers(Map<String, dynamic> searchParams);
  Future<Result<Ride>> createRide(Map<String, dynamic> rideData);
  Future<Result<void>> cancelRide(int id);
  Future<Result<Ride>> finishRide(String id);
  Future<Result<Ride>> acceptRide(String id);
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData);
}

class RideRepository extends RideRepositoryProtocol {
  final ServiceProtocol _service;

  RideRepository({required ServiceProtocol service}) : _service = service;

  @override
  Future<Result<List<Ride>>> getRides({Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _service.getRides(queryParameters: queryParameters);
      if (response is Error) return Result.error(response.error);

      final ridesData = (response as Ok).value as List<dynamic>?;
      if (ridesData == null) return const Result.ok([]);

      final rides = ridesData.map((json) => Ride.fromJson(json)).toList();
      return Result.ok(rides);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<List<Ride>>> searchRide(Map<String, dynamic> searchParams) async {
    try {
      final response = await _service.searchRide(searchParams);
      if (response is Error) return Result.error(response.error);

      final ridesData = (response as Ok).value as List<dynamic>?;
      if (ridesData == null) return const Result.ok([]);

      final rides = ridesData.map((json) => Ride.fromJson(json)).toList();
      return Result.ok(rides);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<List<User>>> searchDrivers(Map<String, dynamic> searchParams) async {
    try {
      final response = await _service.searchDrivers(searchParams);
      if (response is Error) return Result.error(response.error);

      final driversData = (response as Ok).value as List<dynamic>?;
      if (driversData == null) return const Result.ok([]);

      final drivers = driversData.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
      return Result.ok(drivers);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Ride>> createRide(Map<String, dynamic> rideData) async {
    try {
      final response = await _service.createRide(rideData);
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final ride = Ride.fromJson(value);
      return Result.ok(ride);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<void>> cancelRide(int id) async {
    try {
      final response = await _service.cancelRide(id.toString());
      if (response is Error) return Result.error(response.error);

      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Ride>> finishRide(String id) async {
    try {
      final response = await _service.finishRide(id);
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final ride = Ride.fromJson(value);
      return Result.ok(ride);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Ride>> acceptRide(String id) async {
    try {
      final response = await _service.acceptRide(id);
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final ride = Ride.fromJson(value);
      return Result.ok(ride);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData) async {
    try {
      final response = await _service.reviewRide(id, reviewData);
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final review = Review.fromJson(value);
      return Result.ok(review);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
