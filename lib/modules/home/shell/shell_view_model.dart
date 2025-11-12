import 'package:go_router/go_router.dart';

import 'shell_view.dart';

class ShellViewModel extends ShellViewModelProtocol {
  @override
  void didTapProfile() {
    context?.go('/shell/profile/details');
  }
}
