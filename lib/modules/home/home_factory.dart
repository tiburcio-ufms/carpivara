import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/mocks/ride_repository_mock.dart';
import '../../repositories/places_repository.dart';
import '../../services/places_service.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/session_manager.dart';
import 'driver/driver_view.dart';
import 'driver/driver_view_model.dart';
import 'passenger/passenger_view.dart';
import 'passenger/passenger_view_model.dart';
import 'shell/shell_view.dart';
import 'shell/shell_view_model.dart';

class HomeFactory {
  HomeFactory._();

  static Widget driver(BuildContext context) {
    final sessionManager = SessionManager.instance;
    final rideRepository = RideRepositoryMock();
    final viewModel = DriverViewModel(sessionManager: sessionManager, rideRepository: rideRepository);
    return DriverView(viewModel: container.register(viewModel));
  }

  static Widget passenger(BuildContext context) {
    final placesService = PlacesService();
    final sessionManager = SessionManager.instance;
    final rideRepository = RideRepositoryMock();
    final placesRepository = PlacesRepository(service: placesService);
    final viewModel = PassengerViewModel(
      sessionManager: sessionManager,
      rideRepository: rideRepository,
      placesRepository: placesRepository,
    );
    return PassengerView(viewModel: container.register(viewModel));
  }

  static Widget shell(BuildContext context, GoRouterState state) {
    final viewModel = ShellViewModel();
    return ShellView(viewModel: container.register(viewModel));
  }
}
