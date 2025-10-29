import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../support/dependencies/dependency_container.dart';
import 'details/details_view.dart';
import 'details/details_view_model.dart';

class ProfileFactory {
  ProfileFactory._();

  static Widget details(BuildContext context, GoRouterState state) {
    final viewModel = DetailsViewModel();
    return DetailsView(viewModel: container.register(viewModel));
  }
}
