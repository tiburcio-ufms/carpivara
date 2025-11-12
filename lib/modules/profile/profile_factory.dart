import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/address_repository.dart';
import '../../repositories/mocks/address_repository_mock.dart';
import '../../repositories/mocks/ride_repository_mock.dart';
import '../../repositories/ride_repository.dart';
import '../../services/api_service.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/api_client.dart';
import '../../support/utils/session_manager.dart';
import 'details/details_view.dart';
import 'details/details_view_model.dart';
import 'history/history_view.dart';
import 'history/history_view_model.dart';

class ProfileFactory {
  ProfileFactory._();

  static Widget details(BuildContext context, GoRouterState state) {
    final client = ApiClient();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final addressRepository = kDebugMode ? AddressRepositoryMock() : AddressRepository(service: service);
    final viewModel = DetailsViewModel(sessionManager: sessionManager, addressRepository: addressRepository);
    return DetailsView(viewModel: container.register(viewModel));
  }

  static Widget history(BuildContext context, GoRouterState state) {
    final client = ApiClient();
    final service = ApiService(client: client);
    final sessionManager = SessionManager.instance;
    final rideRepository = kDebugMode ? RideRepositoryMock() : RideRepository(service: service);
    final viewModel = HistoryViewModel(sessionManager: sessionManager, rideRepository: rideRepository);
    return HistoryView(viewModel: container.register(viewModel));
  }
}
