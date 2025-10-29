import 'passenger_view.dart';

class PassengerViewModel extends PassengerViewModelProtocol {
  bool _onlyWoman = false;

  @override
  bool get onlyWoman => _onlyWoman;

  @override
  void updateDestination(String destination) {
    // TODO: implement updateDestination
  }

  @override
  void didTapOnlyWomanSwitch(bool value) {
    _onlyWoman = value;
    notifyListeners();
  }
}
