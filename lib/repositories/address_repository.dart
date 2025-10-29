import '../models/address.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class AddressRepositoryProtocol {
  Future<Result<List<Address>>> getAddresses();
}

class AddressRepository extends AddressRepositoryProtocol {
  final ServiceProtocol _service;

  AddressRepository({required ServiceProtocol service}) : _service = service;

  @override
  Future<Result<List<Address>>> getAddresses() async {
    try {
      final response = await _service.getAddresses();
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value as List<dynamic>;
      final addresses = value.map((json) => Address.fromJson(json)).toList();
      return Result.ok(addresses);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
