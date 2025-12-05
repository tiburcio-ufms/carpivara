import 'package:go_router/go_router.dart';

import '../../../repositories/session_repository.dart';
import '../../../support/utils/result.dart';
import '../../../support/utils/session_manager.dart';
import 'sign_in_view.dart';

class SignInViewModel extends SignInViewModelProtocol {
  String? _passport;
  String? _password;
  String? _passportError;
  String? _passwordError;

  final SessionManagerProtocol _sessionManager;
  final SessionRepositoryProtocol _sessionRepository;
  SignInViewModel({
    required SessionManagerProtocol sessionManager,
    required SessionRepositoryProtocol sessionRepository,
  }) : _sessionManager = sessionManager,
       _sessionRepository = sessionRepository;

  @override
  String? get passportError => _passportError;

  @override
  String? get passwordError => _passwordError;

  bool get _isFormValid {
    _passportError = _validatePassport();
    _passwordError = _validatePassword();
    notifyListeners();
    return _passportError == null && _passwordError == null;
  }

  @override
  void didTapSignIn() {
    if (!_isFormValid) return;
    final credentials = {'passport': _passport, 'password': _password};

    setIsLoading(true);
    _sessionRepository.signIn(credentials).then((result) {
      setIsLoading(false);
      switch (result) {
        case Ok(:final value):
          _sessionManager.saveSession(value);
          context?.go('/shell');
        case Error(:final error):
          renderFailure?.call(error.toString());
      }
    });
  }

  @override
  void updatePassport(String passport) {
    _passport = passport;
    notifyListeners();
  }

  @override
  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Private methods -----------------------------------------------------------
  String? _validatePassport() {
    final passport = _passport;
    if (passport == null || passport.isEmpty) return 'Passaporte é obrigatório';
    if (passport.length != 12) return 'Passaporte deve ter 12 caracteres';
    if (passport.contains(RegExp(r'\D'))) return 'Passaporte deve ter apenas números';
  }

  String? _validatePassword() {
    final password = _password;
    if (password == null || password.isEmpty) return 'Senha é obrigatória';
    if (password.length < 8) return 'Senha deve ter pelo menos 8 caracteres';
  }
}
