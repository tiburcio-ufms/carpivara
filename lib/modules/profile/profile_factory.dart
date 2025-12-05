import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/mocks/address_repository_mock.dart';
import '../../repositories/mocks/ride_repository_mock.dart';
import '../../support/dependencies/dependency_container.dart';
import '../../support/utils/session_manager.dart';
import 'details/details_view.dart';
import 'details/details_view_model.dart';
import 'history/history_view.dart';
import 'history/history_view_model.dart';

class ProfileFactory {
  ProfileFactory._();

  static Widget details(BuildContext context, GoRouterState state) {
    if (container.isRegistered<DetailsViewModel>(state.fullPath)) {
      return DetailsView(viewModel: container.getIt<DetailsViewModel>(state.fullPath));
    } else {
      final sessionManager = SessionManager.instance;
      final addressRepository = AddressRepositoryMock();
      final viewModel = DetailsViewModel(sessionManager: sessionManager, addressRepository: addressRepository);
      return DetailsView(viewModel: container.register(viewModel, state.fullPath));
    }
  }

  static Widget history(BuildContext context, GoRouterState state) {
    if (container.isRegistered<HistoryViewModel>(state.fullPath)) {
      return HistoryView(viewModel: container.getIt<HistoryViewModel>(state.fullPath));
    } else {
      final sessionManager = SessionManager.instance;
      final rideRepository = RideRepositoryMock();
      final viewModel = HistoryViewModel(sessionManager: sessionManager, rideRepository: rideRepository);
      return HistoryView(viewModel: container.register(viewModel, state.fullPath));
    }
  }
}
