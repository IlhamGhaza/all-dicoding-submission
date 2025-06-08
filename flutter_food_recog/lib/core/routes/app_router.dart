import 'package:flutter/material.dart';
import 'package:flutter_food_recog/features/home/presentation/pages/home_page.dart';
import 'package:flutter_food_recog/features/camera/presentation/pages/camera_page.dart';
import 'package:flutter_food_recog/features/result/presentation/pages/result_page.dart';

class AppRouter {
  static const String home = '/';
  static const String camera = '/camera';
  static const String result = '/result';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case camera:
        return MaterialPageRoute(builder: (_) => const CameraPage());
      case result:
        final imagePath = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ResultPage(imagePath: imagePath),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
