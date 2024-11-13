import 'package:entain_test/screens/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../screens/home.dart';

class PageRouter {

  PageRouter();

  late final GoRouter pageRouter = GoRouter(
    routes: [
      GoRoute(
        name: '/',
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(const HomePage());
        },
      ),
      GoRoute(
        path: '/user',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return customTransitionPage(
              UserScreen(userId: "${state.uri.queryParameters["id"]!}/"));
        },
      ),
    ],
  );

  CustomTransitionPage<dynamic> customTransitionPage(Widget page) {
    return CustomTransitionPage(
      transitionDuration: const Duration(seconds: 1),
      child: page,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.fastOutSlowIn).animate(animation),
          child: child,
        );
      },
    );
  }
}
