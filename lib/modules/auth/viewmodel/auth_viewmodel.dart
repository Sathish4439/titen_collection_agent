import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/core/utils/toast_helper.dart';
import 'package:collection_agent/core/utils/validators.dart';

/// Authentication ViewModel
/// STRICT RULE: Extends ChangeNotifier, guards notifyListeners(), NO setState()
class AuthViewModel extends ChangeNotifier {
  String _phoneNumber = '56455 565665';
  bool _isLoading = false;
  String? _errorMessage;

  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updatePhoneNumber(String value) {
    if (_phoneNumber == value) return;
    _phoneNumber = value;
    if (_errorMessage != null) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void login() {
    final error = Validators.validatePhone(_phoneNumber);
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      AppToast.error(error);
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Fast seamless login navigation to Room Management
    Future.delayed(const Duration(milliseconds: 300), () {
      _isLoading = false;
      notifyListeners();
      Get.offAllNamed(AppRoutes.roomManagement);
    });
  }
}
