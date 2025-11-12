import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/mocks/places_repository_mock.dart';
import '../../repositories/mocks/ride_repository_mock.dart';
import '../../repositories/places_repository.dart';
import '../../repositories/ride_repository.dart';
import '../../services/api_service.dart';
import '../../services/places_service.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/api_client.dart';
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
    final client = ApiClient();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final rideRepository = kDebugMode ? RideRepositoryMock() : RideRepository(service: service);
    final viewModel = DriverViewModel(sessionManager: sessionManager, rideRepository: rideRepository);
    return DriverView(viewModel: container.register(viewModel));
  }

  static Widget passenger(BuildContext context) {
    final client = ApiClient();
    final placesService = PlacesService();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final rideRepository = kDebugMode ? RideRepositoryMock() : RideRepository(service: service);
    final placesRepository = !kDebugMode ? PlacesRepositoryMock() : PlacesRepository(service: placesService);
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
