import '../models/session.dart';
import '../services/api_service.dart';
import '../support/utils/result.dart';

abstract class SessionRepositoryProtocol {
  Future<Result<Session>> signIn(Map<String, dynamic> credentials);
}

class SessionRepository extends SessionRepositoryProtocol {
  final ServiceProtocol _service;

  SessionRepository({required ServiceProtocol service}) : _service = service;

  @override
  Future<Result<Session>> signIn(Map<String, dynamic> credentials) async {
    try {
      final response = await _service.signIn(credentials);
      if (response is Error) return Result.error(response.error);

      final value = (response as Ok).value;
      final session = Session.fromJson(value);
      return Result.ok(session);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
