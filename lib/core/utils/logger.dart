import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Centralized Logger utility
class AppLogger {
  AppLogger._();

  static void info(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      dev.log('\x1B[34m[$tag] $message\x1B[0m', name: tag);
    }
  }

  static void success(String message, {String tag = 'SUCCESS'}) {
    if (kDebugMode) {
      dev.log('\x1B[32m[$tag] $message\x1B[0m', name: tag);
    }
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      dev.log('\x1B[33m[$tag] $message\x1B[0m', name: tag);
    }
  }

  static void error(String message, {String tag = 'ERROR', Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      dev.log(
        '\x1B[31m[$tag] $message\x1B[0m',
        name: tag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
