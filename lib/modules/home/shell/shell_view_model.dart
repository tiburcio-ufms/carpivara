import 'shell_view.dart';

class ShellViewModel extends ShellViewModelProtocol {
  String _destination = '';

  @override
  void didTapTab(int index) {
    // TODO: implement didTapTab
  }

  @override
  void updateDestination(String destination) {
    _destination = destination;
    notifyListeners();
  }
}
