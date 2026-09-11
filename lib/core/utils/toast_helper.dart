import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';

/// Centralized Toast/Notification Service
/// STRICT RULE: Direct calls to Get.snackbar() or ScaffoldMessenger in views are forbidden.
class AppToast {
  AppToast._();

  static void success(String message, {String title = 'Success'}) {
    if (Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      titleText: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      ),
    );
  }

  static void error(String message, {String title = 'Error'}) {
    if (Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      titleText: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      ),
    );
  }

  static void info(String message, {String title = 'Notice'}) {
    if (Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white),
      titleText: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
      ),
      messageText: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      ),
    );
  }
}
