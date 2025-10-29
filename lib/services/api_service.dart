import '../support/utils/api_client.dart';
import '../support/utils/result.dart';

abstract class ServiceProtocol {
  Future<Result> getAddresses();
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
}
