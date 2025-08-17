class AppConfig {
  static const appVariant =
      String.fromEnvironment('APP_VARIANT', defaultValue: 'free');

  static bool get isPaidFlavor => appVariant == 'paid';

  // Read Google Maps API key from --dart-define at build/run time
  // Example: flutter run --dart-define=GMAPS_API_KEY=YOUR_KEY
  static const gmapsApiKey =
      String.fromEnvironment('GMAPS_API_KEY', defaultValue: '');

  // Consider Google Maps available only when a non-empty key is provided
  static bool get hasGoogleMapsApiKey => gmapsApiKey.isNotEmpty;
}
