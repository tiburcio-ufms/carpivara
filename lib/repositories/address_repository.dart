import '../models/address.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class AddressRepositoryProtocol {
  Future<Result<List<Address>>> getAddresses();
  Future<Result<Address>> createAddress(Address address);
  Future<Result<Address>> updateAddress(Address address);
  Future<Result<void>> deleteAddress(int id);
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

  @override
  Future<Result<Address>> createAddress(Address address) async {
    try {
      final response = await _service.createAddress(address.toJson());
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value as Map<String, dynamic>;
      final createdAddress = Address.fromJson(value);
      return Result.ok(createdAddress);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<Address>> updateAddress(Address address) async {
    try {
      if (address.id == null) return Result.error(Exception('Address ID is required for update'));
      final response = await _service.updateAddress(address.id.toString(), address.toJson());
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value as Map<String, dynamic>;
      final updatedAddress = Address.fromJson(value);
      return Result.ok(updatedAddress);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result<void>> deleteAddress(int id) async {
    try {
      final response = await _service.deleteAddress(id.toString());
      if (response is Error) return Result.error(response.error);

      return const Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
