import '../support/utils/api_client.dart';
import '../support/utils/result.dart';

abstract class ServiceProtocol {
  Future<Result> getAddresses();
  Future<Result> deleteAddress(String id);
  Future<Result> createAddress(dynamic body);
  Future<Result> updateAddress(String id, dynamic body);

  Future<Result> getRides();
  Future<Result> acceptRide(String id);
  Future<Result> searchRide(dynamic body);
  Future<Result> reviewRide(String id, dynamic body);

  Future<Result> signIn(dynamic body);
  Future<Result> getProfile();
}

class ApiService extends ServiceProtocol {
  final ApiClientProtocol _client;

  ApiService({required ApiClientProtocol client}) : _client = client;

  @override
  Future<Result> getAddresses() async {
    try {
      final response = await _client.get('/addresses');
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> createAddress(dynamic body) async {
    try {
      final response = await _client.post('/addresses', body);
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> updateAddress(String id, dynamic body) async {
    try {
      final response = await _client.put('/addresses/$id', body);
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> deleteAddress(String id) async {
    try {
      final response = await _client.delete('/addresses/$id');
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> signIn(dynamic body) async {
    try {
      final response = await _client.post('/auth/sign-in', body);
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> searchRide(dynamic body) async {
    try {
      final response = await _client.post('/rides/search', body);
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> acceptRide(String id) async {
    try {
      final response = await _client.post('/rides/$id/accept', {});
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> reviewRide(String id, dynamic body) async {
    try {
      final response = await _client.post('/rides/$id/review', body);
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> getRides() async {
    try {
      final response = await _client.get('/rides');
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> getProfile() async {
    try {
      final response = await _client.get('/profile');
      return response;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
