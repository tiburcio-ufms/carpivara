import 'package:get_it/get_it.dart';

final container = DependencyContainer._();

class DependencyContainer {
  static final GetIt _getIt = GetIt.instance;
  DependencyContainer._();

  Future<void> unregister<T extends Object>(T instance) async {
    await _getIt.unregister<T>(instance: instance);
  }

  T register<T extends Object>(T instance) {
    if (_getIt.isRegistered<T>()) return _getIt.get<T>();
    return _getIt.registerSingleton<T>(instance);
  }
}
