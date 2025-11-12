import 'package:flutter/widgets.dart';

typedef RenderDialog = Future<T?> Function<T>(Widget dialog);
typedef RenderFailure = void Function(String message);

abstract class ViewModel extends ChangeNotifier {
  bool? _isLoading;
  BuildContext? _context;
  RenderDialog? _renderDialog;
  RenderFailure? _renderFailure;

  bool get isLoading => _isLoading ?? false;
  BuildContext? get context => _context;
  RenderDialog? get renderDialog => _renderDialog;
  RenderFailure? get renderFailure => _renderFailure;

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setContext(BuildContext? context) {
    _context = context;
    notifyListeners();
  }

  void setRenderDialog(RenderDialog renderDialog) {
    _renderDialog = renderDialog;
    notifyListeners();
  }

  void setRenderFailure(void Function(String message) renderFailure) {
    _renderFailure = renderFailure;
    notifyListeners();
  }
}
