import 'package:flutter/widgets.dart';

abstract class ViewModel extends ChangeNotifier {
  bool _isLoading = false;
  late BuildContext _context;

  bool get isLoading => _isLoading;
  BuildContext get context => _context;

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
}
