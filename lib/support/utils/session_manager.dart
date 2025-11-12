import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/session.dart';

abstract class SessionManagerProtocol {
  bool get hasSession;
  Session? get session;
  Future<bool> verifySession();
  Future<void> removeSession();
  Future<void> saveSession(Session session);
}

class SessionManager extends SessionManagerProtocol {
  Session? _session;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static final SessionManagerProtocol instance = SessionManager._();

  /// Init
  SessionManager._();

  /// SessionManagerProtocol
  @override
  Session? get session => _session;

  @override
  bool get hasSession => _session != null;

  @override
  Future<bool> verifySession() async {
    if (_session != null) return true;

    final session = await _secureStorage.read(key: 'session');
    if (session == null) return false;
    _session = Session.fromJson(jsonDecode(session));
    return true;
  }

  @override
  Future<void> removeSession({bool isToRedirect = true}) async {
    _session = null;
    await _secureStorage.deleteAll();
  }

  @override
  Future<void> saveSession(Session session) async {
    _session = session;
    await _secureStorage.write(key: 'session', value: jsonEncode(session.toJson()));
  }
}
