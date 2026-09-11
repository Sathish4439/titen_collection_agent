import 'package:collection_agent/core/constants/app_strings.dart';

/// Centralized Validators
class Validators {
  Validators._();

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequiredError;
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 10) {
      return AppStrings.phoneInvalidError;
    }
    return null;
  }

  static String? validateAmount(String? value, double amountDue) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.paymentInvalidAmount;
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return AppStrings.paymentInvalidAmount;
    }
    if (parsed > amountDue) {
      return AppStrings.paymentExceedsDue;
    }
    return null;
  }
}
