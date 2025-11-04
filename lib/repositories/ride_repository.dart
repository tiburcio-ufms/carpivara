import '../models/review.dart';
import '../models/ride.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class RideRepositoryProtocol {
  Future<Result<List<Ride>>> getRides();
  Future<Result<List<Ride>>> searchRide(Map<String, dynamic> searchParams);
  Future<Result<Ride>> acceptRide(String id);
  Future<Result<Review>> reviewRide(String id, Map<String, dynamic> reviewData);
}

class RideRepository extends RideRepositoryProtocol {
  final ServiceProtocol _service;

  RideRepository({required ServiceProtocol service}) : _service = service;

  @override
  Future<Result<List<Ride>>> getRides() async {
    try {
      final response = await _service.getRides();
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
