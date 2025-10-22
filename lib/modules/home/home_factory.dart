import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../support/dependencies/dependency_container.dart';
import 'driver/driver_view.dart';
import 'driver/driver_view_model.dart';
import 'passenger/passenger_view.dart';
import 'passenger/passenger_view_model.dart';
import 'shell/shell_view.dart';
import 'shell/shell_view_model.dart';

class HomeFactory {
  HomeFactory._();

  static Widget driver(BuildContext context) {
    final viewModel = DriverViewModel();
    return DriverView(viewModel: container.register(viewModel));
  }

  static Widget passenger(BuildContext context) {
    final viewModel = PassengerViewModel();
    return PassengerView(viewModel: container.register(viewModel));
  }

  static Widget shell(BuildContext context, GoRouterState state) {
    final viewModel = ShellViewModel();
    return ShellView(viewModel: container.register(viewModel));
  }
}
