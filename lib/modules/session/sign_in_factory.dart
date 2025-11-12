import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/mocks/session_repository_mock.dart';
import '../../repositories/session_repository.dart';
import '../../services/api_service.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/api_client.dart';
import '../../support/utils/session_manager.dart';
import 'sign_in/sign_in_view.dart';
import 'sign_in/sign_in_view_model.dart';

class SignInFactory {
  SignInFactory._();

  static Widget signIn(BuildContext context, GoRouterState state) {
    final client = ApiClient();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final sessionRepository = kDebugMode ? SessionRepositoryMock() : SessionRepository(service: service);
    final viewModel = SignInViewModel(sessionRepository: sessionRepository, sessionManager: sessionManager);
    return SignInView(viewModel: container.register(viewModel));
  }
}
