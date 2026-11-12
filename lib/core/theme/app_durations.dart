final class AppDurations {
  const AppDurations._();

  static const Duration check = Duration(milliseconds: 300);
  static const Duration toast = Duration(seconds: 2);
  static const Duration remoteSync = Duration(seconds: 20);
  static const Duration serverAck = Duration(seconds: 4);
  static const Duration syncRetry = Duration(seconds: 15);
}
