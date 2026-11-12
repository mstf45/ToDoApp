import 'package:flutter/foundation.dart';

final class AppLogger {
  const AppLogger._();

  static const String _info = 'INFO';
  static const String _error = 'ERROR';

  static void info(String message) {
    _write(_info, message);
  }

  static void error(String message, Object error, StackTrace stackTrace) {
    if (!kDebugMode) return;
    debugPrint('[$_error] $message');
    debugPrint('$error');
    debugPrint('$stackTrace');
  }

  static void _write(String level, String message) {
    if (!kDebugMode) return;
    debugPrint('[$level] $message');
  }
}
