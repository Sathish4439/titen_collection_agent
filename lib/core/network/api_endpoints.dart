import 'package:flutter/foundation.dart';

/// Central API Endpoints & Base URL Configuration
class ApiEndpoints {
  ApiEndpoints._();

  /// Default Titanstay Collector API Base URL
  static String get defaultBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kIsWeb) {
      return 'http://localhost:3000/api/v1/collector';
    }
    // Production API endpoint for Android & iOS mobile builds
   return 'https://pg-admin-api.titanstay.com/api/v1/collector';
   // return 'http://192.168.31.86:3000/api/v1/collector';
  }

  // Endpoints relative to base URL
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/me';
  static const String dashboard = '/dashboard';
  static const String collectPayment = '/payments/collect';
  static const String paymentHistory = '/payments/history';
  static const String customerDetails = '/customers';
}
