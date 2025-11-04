import '../models/user.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class ProfileRepositoryProtocol {
  Future<Result<User>> getProfile();
}

class ProfileRepository extends ProfileRepositoryProtocol {
  final ServiceProtocol _service;

  ProfileRepository({required ServiceProtocol service}) : _service = service;

  @override
  Future<Result<User>> getProfile() async {
    try {
      final response = await _service.getProfile();
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final user = User.fromJson(value);
      return Result.ok(user);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
