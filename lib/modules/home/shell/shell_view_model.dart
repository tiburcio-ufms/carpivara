import 'package:go_router/go_router.dart';

import 'shell_view.dart';

class ShellViewModel extends ShellViewModelProtocol {
  String _destination = '';

  @override
  void didTapProfile() {
    context.go('/shell/profile/details');
  }

  @override
  void updateDestination(String destination) {
    _destination = destination;
    notifyListeners();
  }
}
