import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_scren.dart';
import '../screens/home/presentation/add_story_screen.dart';
import '../screens/home/presentation/home_screen.dart';
import '../screens/home/presentation/story_detail_screen.dart';
import '../screens/maps/select_location_screen.dart';

class AppRouter {
  static const String splashPath = '/splash';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/';
  static const String addStoryPath = '/add-story';
  static const String storyDetailPath = '/story/:storyId';
  static const String selectLocationPath = '/select-location';

  static GoRouter router(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return GoRouter(
      initialLocation: splashPath,
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: splashPath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: loginPath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: registerPath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: homePath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: addStoryPath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AddStoryPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                    Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: storyDetailPath,
          pageBuilder: (context, state) {
            final story = state.extra as Story?;
            if (story == null) {
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: Scaffold(
                    body: Center(
                        child: Text('Story not found or invalid parameters.'))),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              );
            }
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: StoryDetailPage(story: story),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            );
          },
        ),
        GoRoute(
          path: selectLocationPath,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SelectLocationScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                    Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.ease))),
                child: child,
              );
            },
          ),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authProvider.isLoggedIn;
        final bool loggingIn = state.matchedLocation == loginPath ||
            state.matchedLocation == registerPath;
        final bool splashing = state.matchedLocation == splashPath;

        if (splashing) {
          return null;
        }

        if (!loggedIn && !loggingIn) {
          return loginPath;
        }

        if (loggedIn && loggingIn) {
          return homePath;
        }

        return null;
      },
    );
  }
}
