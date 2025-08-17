class StorageKeys {
  static const String userId = 'userId';
  static const String token = 'token';
  static const String isDarkMode = 'isDarkMode';
  static const String locale = 'locale';
}

class ApiEndpoints {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  static const String login = '/login';
  static const String register = '/register';
  static const String stories = '/stories';
}

class AppConstants {
  static const int pageSize = 10;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 4);
}
