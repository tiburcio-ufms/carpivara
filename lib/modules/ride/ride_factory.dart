import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../support/dependencies/dependency_container.dart';
import 'live/live_view.dart';
import 'live/live_view_model.dart';

class RideFactory {
  RideFactory._();

  static Widget live(BuildContext context, GoRouterState state) {
    final viewModel = LiveViewModel();
    return LiveView(viewModel: container.register(viewModel));
  }
}
