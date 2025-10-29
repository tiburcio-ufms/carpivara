import 'driver_view.dart';

class DriverViewModel extends DriverViewModelProtocol {
  bool _onlyWoman = false;

  @override
  bool get onlyWoman => _onlyWoman;

  @override
  void didTapAcceptRide() {
    // TODO: implement acceptRide
  }

  @override
  void didTapRejectRide() {
    // TODO: implement rejectRide
  }

  @override
  void didTapOnlyWomanSwitch(bool value) {
    _onlyWoman = value;
    notifyListeners();
  }

  // Private methods -----------------------------------------------------------
  void _showRideAlert() {
    Future.delayed(const Duration(seconds: 3), () {
      showRideAlert?.call();
    });
  }
}
