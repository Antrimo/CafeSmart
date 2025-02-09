import 'package:cafesmart/screens/introduction/app_introduction.dart';
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
          return const AppIntroduction();
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/menu',
            builder: (BuildContext context, GoRouterState state) {
              return const DrawerMenu();
            },
          ),
        ]
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
