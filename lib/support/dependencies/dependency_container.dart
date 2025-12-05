import 'package:get_it/get_it.dart';

final container = DependencyContainer._();

class DependencyContainer {
  static final GetIt _getIt = GetIt.instance;
  DependencyContainer._();

  T getIt<T extends Object>([String? name]) {
    return _getIt.get<T>(instanceName: name);
  }

  bool isRegistered<T extends Object>([String? name]) {
    return _getIt.isRegistered<T>(instanceName: name);
  }

  T register<T extends Object>(T instance, [String? name]) {
    if (isRegistered<T>(name)) return getIt<T>(name);
    return _getIt.registerSingleton<T>(instance, instanceName: name);
  }

  Future<void> unregister<T extends Object>(T instance, [String? name]) async {
    await _getIt.unregister<T>(instance: instance, instanceName: name);
  }
}
