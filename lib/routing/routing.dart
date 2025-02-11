import 'package:cafesmart/screens/app_introduction_screen.dart';
import 'package:cafesmart/screens/introduction/introduction_structure.dart';
import 'package:cafesmart/widgets/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routing extends StatelessWidget {
  const Routing({super.key});

  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const AppIntroductionScreen();
        },
      ),
      GoRoute(
        path: '/menu',
        builder: (BuildContext context, GoRouterState state) {
          return const IntroductionStructure();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const DrawerMenu();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
