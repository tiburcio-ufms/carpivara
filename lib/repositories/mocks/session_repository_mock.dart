import 'dart:async';

import '../../models/session.dart';
import '../../models/user.dart';
import '../../support/utils/result.dart';
import '../session_repository.dart';

class SessionRepositoryMock implements SessionRepositoryProtocol {
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<Result<Session>> signIn(Map<String, dynamic> credentials) async {
    await _simulateNetworkDelay();

    final passport = credentials['passport'] as String? ?? '';
    final password = credentials['password'] as String? ?? '';

    if (password.length < 6) return Result.error(Exception('Credenciais inválidas'));
    if (passport.isEmpty || password.isEmpty) return Result.error(Exception('Passaporte e senha são obrigatórios'));

    final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    final user = User(
      id: 1,
      isWoman: true,
      name: 'Camila Ribeiro',
      passport: passport,
      course: 'Sistemas de Informação',
      profilePic: '/assets/woman_avatar_1.png',
      rating: '4.8',
      ridesAsDriver: '12',
      ridesAsPassenger: '24',
      semester: '5º Semestre',
    );

    return Result.ok(Session(token: token, user: user));
  }
}
