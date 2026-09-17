import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection_agent/app/routes/app_routes.dart';
import 'package:collection_agent/core/network/api_client.dart';
import 'package:collection_agent/core/utils/toast_helper.dart';
import 'package:collection_agent/core/utils/validators.dart';
import 'package:collection_agent/shared/models/collector_model.dart';
import 'package:collection_agent/shared/repositories/collector_repository.dart';

/// Authentication ViewModel
/// STRICT RULE: Extends ChangeNotifier, guards notifyListeners(), NO setState()
class AuthViewModel extends ChangeNotifier {
  final CollectorRepository _repository = CollectorRepository.instance;

  String _phoneNumber = '';
  String _passcode = '';
  String _tenantId = '';
  bool _isLoading = false;
  String? _errorMessage;
  CollectorModel? _authenticatedCollector;

  String get phoneNumber => _phoneNumber;
  String get passcode => _passcode;
  String get tenantId => _tenantId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CollectorModel? get authenticatedCollector => _authenticatedCollector;

  void updatePhoneNumber(String value) {
    if (_phoneNumber == value) return;
    _phoneNumber = value;
    if (_errorMessage != null) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void updatePasscode(String value) {
    if (_passcode == value) return;
    _passcode = value;
    if (_errorMessage != null) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void updateTenantId(String value) {
    if (_tenantId == value) return;
    _tenantId = value;
    notifyListeners();
  }

  Future<void> login() async {
    final phoneError = Validators.validatePhone(_phoneNumber);
    if (phoneError != null) {
      _errorMessage = phoneError;
      notifyListeners();
      AppToast.error(phoneError);
      return;
    }

    final passcodeError = Validators.validatePasscode(_passcode);
    if (passcodeError != null) {
      _errorMessage = passcodeError;
      notifyListeners();
      AppToast.error(passcodeError);
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final collector = await _repository.loginWithPasscode(
        phone: _phoneNumber,
        passcode: _passcode,
        tenantId: _tenantId,
      );

      _authenticatedCollector = collector;
      _isLoading = false;
      notifyListeners();

      AppToast.success('Login successful. Welcome ${collector.name}!');
      Get.offAllNamed(AppRoutes.roomManagement);
    } catch (e) {
      _isLoading = false;
      final errorMsg = e is ApiException ? e.message : e.toString();
      _errorMessage = errorMsg;
      notifyListeners();
      AppToast.error(errorMsg);
    }
  }

  /// Load cached collector profile from local storage if available
  Future<void> loadCachedCollector() async {
    if (_authenticatedCollector != null) return;
    final cached = await _repository.getCachedCollector();
    if (cached != null) {
      _authenticatedCollector = cached;
      _phoneNumber = cached.phone;
      notifyListeners();
    }
  }

  /// Logout current collector, wipe storage, and navigate to login
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.logout();
      _authenticatedCollector = null;
      _passcode = '';
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();

      AppToast.info('Logged out successfully');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      AppToast.error('Logout error: $e');
    }
  }
}
