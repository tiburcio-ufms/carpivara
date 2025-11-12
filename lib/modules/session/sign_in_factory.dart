import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/mocks/session_repository_mock.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/session_manager.dart';
import 'sign_in/sign_in_view.dart';
import 'sign_in/sign_in_view_model.dart';

class SignInFactory {
  SignInFactory._();

  static Widget signIn(BuildContext context, GoRouterState state) {
    final sessionManager = SessionManager.instance;
    final sessionRepository = SessionRepositoryMock();
    final viewModel = SignInViewModel(sessionRepository: sessionRepository, sessionManager: sessionManager);
    return SignInView(viewModel: container.register(viewModel));
  }
}
