final class AppEnvironment {
  const AppEnvironment._();

  static const String flavorKey = 'FLAVOR';
  static const String devName = 'dev';
  static const String prodName = 'prod';

  /// `--dart-define=FLAVOR=prod` dışında her değer geliştirme ortamıdır.
  static const String flavorName = String.fromEnvironment(
    flavorKey,
    defaultValue: devName,
  );

  static bool get isProd => flavorName == prodName;

  static bool get isDev => !isProd;

  static String windowTitle(String title) {
    if (isProd) return title;
    return '$title ($flavorName)';
  }
}
