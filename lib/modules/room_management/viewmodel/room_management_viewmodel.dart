import 'package:flutter/material.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/utils/toast_helper.dart';
import 'package:collection_agent/core/utils/validators.dart';
import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/block_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';
import 'package:collection_agent/shared/repositories/mock_property_repository.dart';

/// Room Management ViewModel
/// STRICT RULES: Extends ChangeNotifier, NO setState(), guards all notifyListeners()
class RoomManagementViewModel extends ChangeNotifier {
  final MockPropertyRepository _repository = MockPropertyRepository.instance;

  List<BlockModel> _blocks = [];
  String _selectedBlockId = 'ALL';
  List<RoomModel> _rooms = [];

  int _totalRooms = 10;
  int _totalBeds = 22;

  // Active Payment State
  BedModel? _activeBedForPayment;
  String? _activeRoomNumberForPayment;
  String _paymentType = AppStrings.selectPayment;
  String _selectedPaymentOption = AppStrings.selectPaymentOption;
  final TextEditingController paymentAmountController = TextEditingController();
  bool _isSubmittingPayment = false;

  // Active Tenant Details State
  TenantModel? _activeTenantForDetails;

  RoomManagementViewModel() {
    loadData();
  }

  // Getters
  List<BlockModel> get blocks => _blocks;
  String get selectedBlockId => _selectedBlockId;
  List<RoomModel> get rooms => _rooms;
  int get totalRooms => _totalRooms;
  int get totalBeds => _totalBeds;

  BedModel? get activeBedForPayment => _activeBedForPayment;
  String? get activeRoomNumberForPayment => _activeRoomNumberForPayment;
  String get paymentType => _paymentType;
  String get selectedPaymentOption => _selectedPaymentOption;
  String get paymentAmountText => paymentAmountController.text;
  bool get isSubmittingPayment => _isSubmittingPayment;
  TenantModel? get activeTenantForDetails => _activeTenantForDetails;

  String get currentBlockName {
    if (_selectedBlockId == 'ALL') {
      return _blocks.isNotEmpty ? _blocks.first.name : 'A-Block';
    }
    final block = _blocks.firstWhere(
      (b) => b.id == _selectedBlockId,
      orElse: () => _blocks.first,
    );
    return block.name;
  }

  String get currentBlockSummary {
    final block = _blocks.isNotEmpty ? _blocks.first : null;
    if (block == null) return '3 Rooms • Beds: 5/6 (1 vacant)';
    return '${block.totalRooms} ${AppStrings.roomsCountSuffix} • ${AppStrings.bedsCountPrefix} ${block.occupiedBeds}/${block.totalBeds} (${block.vacantBeds} ${AppStrings.vacantLabel})';
  }

  void loadData() {
    _blocks = _repository.getBlocks();
    _totalRooms = _repository.getTotalRooms();
    _totalBeds = _repository.getTotalBeds();
    _rooms = _repository.getRooms(blockId: _selectedBlockId);
    notifyListeners();
  }

  void filterBlock(String blockId) {
    if (_selectedBlockId == blockId) return;
    _selectedBlockId = blockId;
    _rooms = _repository.getRooms(blockId: _selectedBlockId);
    notifyListeners();
  }

  void selectBedForPayment(RoomModel room, BedModel bed) {
    _activeRoomNumberForPayment = room.roomNumber;
    _activeBedForPayment = bed;
    _paymentType = AppStrings.selectPayment;
    _selectedPaymentOption = AppStrings.selectPaymentOption;
    paymentAmountController.text = '';
    notifyListeners();
  }

  void updatePaymentType(String type) {
    if (_paymentType == type) return;
    _paymentType = type;
    if (type == AppStrings.fullPayment && _activeBedForPayment != null) {
      paymentAmountController.text = _activeBedForPayment!.amountDue.toStringAsFixed(0);
    } else if (type == AppStrings.partialPayment) {
      paymentAmountController.text = '';
    }
    notifyListeners();
  }

  void updatePaymentOption(String option) {
    if (_selectedPaymentOption == option) return;
    _selectedPaymentOption = option;
    notifyListeners();
  }

  void updatePaymentAmount(String amount) {
    if (paymentAmountController.text == amount) return;
    paymentAmountController.text = amount;
    notifyListeners();
  }

  void selectTenantForDetails(TenantModel tenant) {
    _activeTenantForDetails = tenant;
    notifyListeners();
  }

  void clearActiveModals() {
    _activeBedForPayment = null;
    _activeRoomNumberForPayment = null;
    _paymentType = AppStrings.selectPayment;
    paymentAmountController.text = '';
    _activeTenantForDetails = null;
    _isSubmittingPayment = false;
    notifyListeners();
  }

  bool submitPayment() {
    if (_activeBedForPayment == null) return false;

    if (_paymentType == AppStrings.selectPayment) {
      AppToast.error(AppStrings.selectPaymentTypeError);
      return false;
    }

    if (_selectedPaymentOption == AppStrings.selectPaymentOption) {
      AppToast.error(AppStrings.paymentSelectOptionError);
      return false;
    }

    final validationError = Validators.validateAmount(
      paymentAmountController.text,
      _activeBedForPayment!.amountDue,
    );
    if (validationError != null) {
      AppToast.error(validationError);
      return false;
    }

    final amountToPay = double.parse(paymentAmountController.text.trim());

    _isSubmittingPayment = true;
    notifyListeners();

    _repository.recordPayment(
      bedId: _activeBedForPayment!.id,
      amount: amountToPay,
      paymentOption: _selectedPaymentOption,
    );

    // Refresh rooms state
    _rooms = _repository.getRooms(blockId: _selectedBlockId);
    _isSubmittingPayment = false;
    _activeBedForPayment = null;
    _activeRoomNumberForPayment = null;
    paymentAmountController.text = '';

    notifyListeners();
    AppToast.success(AppStrings.paymentSuccess);
    return true;
  }

  @override
  void dispose() {
    paymentAmountController.dispose();
    super.dispose();
  }
}
