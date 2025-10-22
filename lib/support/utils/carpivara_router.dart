import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../modules/home/home_factory.dart';
import '../../modules/session/sign_in_factory.dart';

class CarpivaraRouter {
  CarpivaraRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter config = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/sign-in',
    routes: <RouteBase>[
      GoRoute(path: '/shell', builder: HomeFactory.shell),
      GoRoute(path: '/sign-in', builder: SignInFactory.signIn),
    ],
  );
}
