import 'package:go_router/go_router.dart';

import 'sign_in_view.dart';

class SignInViewModel extends SignInViewModelProtocol {
  String _passport = '';
  String _password = '';

  @override
  void didTapSignIn() {
    context.go('/shell');
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
}
