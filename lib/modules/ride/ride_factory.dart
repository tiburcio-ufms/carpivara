import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../models/ride.dart';
import '../../repositories/mocks/places_repository_mock.dart';
import '../../repositories/mocks/ride_repository_mock.dart';
import '../../repositories/places_repository.dart';
import '../../repositories/ride_repository.dart';
import '../../services/api_service.dart';
import '../../services/places_service.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/api_client.dart';
import '../../support/utils/session_manager.dart';
import 'live/live_view.dart';
import 'live/live_view_model.dart';

class RideFactory {
  RideFactory._();

  static Widget live(BuildContext context, GoRouterState state) {
    final ride = state.extra as Ride?;
    final client = ApiClient();
    final placesService = PlacesService();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final rideRepository = kDebugMode ? RideRepositoryMock() : RideRepository(service: service);
    final placesRepository = !kDebugMode ? PlacesRepositoryMock() : PlacesRepository(service: placesService);
    final viewModel = LiveViewModel(
      ride: ride,
      sessionManager: sessionManager,
      rideRepository: rideRepository,
      placesRepository: placesRepository,
    );
    return LiveView(viewModel: container.register(viewModel));
  }
}
