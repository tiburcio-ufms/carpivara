import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../support/dependencies/dependency_container.dart';
import 'sign_in/sign_in_view.dart';
import 'sign_in/sign_in_view_model.dart';

class SignInFactory {
  SignInFactory._();

  static Widget signIn(BuildContext context, GoRouterState state) {
    final viewModel = SignInViewModel();
    return SignInView(viewModel: container.register(viewModel));
  }
}
