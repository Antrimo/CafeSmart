import 'package:cafesmart/screens/authentication/login_screen.dart';
import 'package:cafesmart/screens/authentication/signup_screen.dart';
import 'package:cafesmart/screens/splash_screen.dart';
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
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
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
