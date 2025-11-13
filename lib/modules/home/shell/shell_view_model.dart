import 'package:go_router/go_router.dart';

import '../../../support/utils/constants.dart';
import '../../../support/utils/session_manager.dart';
import 'shell_view.dart';

class ShellViewModel extends ShellViewModelProtocol {
  final SessionManagerProtocol _sessionManager;
  ShellViewModel({required SessionManagerProtocol sessionManager}) : _sessionManager = sessionManager;

  @override
  String get profilePic => _sessionManager.session?.user.profilePic ?? Constants.avatar;

  @override
  void didTapProfile() {
    context?.go('/shell/profile/details');
  }
}
