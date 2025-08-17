class AppConfig {
  static const appVariant =
      String.fromEnvironment('APP_VARIANT', defaultValue: 'free');

  static bool get isPaidFlavor => appVariant == 'paid';
}
