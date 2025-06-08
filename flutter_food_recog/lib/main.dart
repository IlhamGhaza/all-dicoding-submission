import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_recog/core/theme/app_theme.dart';
import 'package:flutter_food_recog/core/routes/app_router.dart';
import 'package:flutter_food_recog/core/providers/camera_provider.dart';
import 'package:flutter_food_recog/core/providers/food_recognition_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => FoodRecognitionProvider()),
      ],
      child: MaterialApp(
        title: 'Food Recognition',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.home,
      ),
    );
  }
}
