import 'package:flutter/material.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/network/api_client.dart';
import 'package:collection_agent/core/utils/toast_helper.dart';
import 'package:collection_agent/core/utils/validators.dart';
import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/block_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';
import 'package:collection_agent/shared/repositories/collector_repository.dart';

/// Room Management ViewModel integrating live Titanstay Collector API
/// STRICT RULES: Extends ChangeNotifier, NO setState(), guards all notifyListeners()
class RoomManagementViewModel extends ChangeNotifier {
  final CollectorRepository _repository = CollectorRepository.instance;

  List<BlockModel> _allBlocks = [];
  List<BlockModel> _blocks = [];
  String _selectedBlockId = 'ALL';
  List<RoomModel> _rooms = [];

  int _totalRooms = 0;
  int _totalBeds = 0;
  double _todayCollected = 0.0;
  bool _isLoading = false;
  String _searchQuery = '';

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
  List<BlockModel> get blocks => _allBlocks.isNotEmpty ? _allBlocks : _blocks;
  String get selectedBlockId => _selectedBlockId;
  List<RoomModel> get rooms => _rooms;
  int get totalRooms => _totalRooms;
  int get totalBeds => _totalBeds;
  double get todayCollected => _todayCollected;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  BedModel? get activeBedForPayment => _activeBedForPayment;
  String? get activeRoomNumberForPayment => _activeRoomNumberForPayment;
  String get paymentType => _paymentType;
  String get selectedPaymentOption => _selectedPaymentOption;
  String get paymentAmountText => paymentAmountController.text;
  bool get isSubmittingPayment => _isSubmittingPayment;
  TenantModel? get activeTenantForDetails => _activeTenantForDetails;

  String get currentBlockName {
    if (_selectedBlockId == 'ALL') {
      return AppStrings.allBlocks;
    }
    final source = _allBlocks.isNotEmpty ? _allBlocks : _blocks;
    final block = source.firstWhere(
      (b) => b.id == _selectedBlockId,
      orElse: () => source.isNotEmpty
          ? source.first
          : const BlockModel(id: '', name: 'Block', totalRooms: 0, occupiedBeds: 0, totalBeds: 0),
    );
    return block.name;
  }

  String get currentBlockSummary {
    if (_selectedBlockId == 'ALL') {
      final source = _allBlocks.isNotEmpty ? _allBlocks : _blocks;
      int totalRooms = 0;
      int occupiedBeds = 0;
      int totalBeds = 0;
      int vacantBeds = 0;
      for (final b in source) {
        totalRooms += b.totalRooms;
        occupiedBeds += b.occupiedBeds;
        totalBeds += b.totalBeds;
        vacantBeds += b.vacantBeds;
      }
      return '$totalRooms ${AppStrings.roomsCountSuffix} • ${AppStrings.bedsCountPrefix} $occupiedBeds/$totalBeds ($vacantBeds ${AppStrings.vacantLabel})';
    }
    final block = _blocks.isNotEmpty ? _blocks.first : null;
    if (block == null) return '0 Rooms';
    return '${block.totalRooms} ${AppStrings.roomsCountSuffix} • ${AppStrings.bedsCountPrefix} ${block.occupiedBeds}/${block.totalBeds} (${block.vacantBeds} ${AppStrings.vacantLabel})';
  }

  Future<void> loadData({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final int? blockIdParam = (_selectedBlockId == 'ALL')
          ? null
          : int.tryParse(_selectedBlockId);

      final dashboardData = await _repository.getDashboard(
        search: _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : null,
        blockId: blockIdParam,
      );

      if (_selectedBlockId == 'ALL' || _allBlocks.isEmpty) {
        _allBlocks = dashboardData.blocks;
      }
      _blocks = dashboardData.blocks;
      _rooms = dashboardData.rooms;
      _totalRooms = dashboardData.totalRooms;
      _todayCollected = dashboardData.todayCollected;

      int calculatedBeds = 0;
      for (final r in _rooms) {
        calculatedBeds += r.totalBeds;
      }
      _totalBeds = calculatedBeds;
    } catch (e) {
      debugPrint('[RoomManagementViewModel] Error loading dashboard: $e');
      if (e is ApiException) {
        AppToast.error(e.message);
      } else {
        AppToast.error('Failed to load dashboard data');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterBlock(String blockId) {
    if (_selectedBlockId == blockId) return;
    _selectedBlockId = blockId;
    loadData();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadData();
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

  Future<bool> submitPayment() async {
    if (_activeBedForPayment == null) return false;

    if (_paymentType == AppStrings.selectPayment) {
      AppToast.error(AppStrings.selectPaymentTypeError);
      return false;
    }

    if (_selectedPaymentOption == AppStrings.selectPaymentOption) {
      AppToast.error(AppStrings.paymentSelectOptionError);
      return false;
    }

    final totalDue = _activeBedForPayment!.amountDue;

    if (_paymentType == AppStrings.fullPayment) {
      paymentAmountController.text = totalDue.toStringAsFixed(0);
    } else if (_paymentType == AppStrings.partialPayment) {
      final parsedAmount = double.tryParse(paymentAmountController.text.trim()) ?? 0.0;
      if (parsedAmount >= totalDue) {
        AppToast.error(AppStrings.partialPaymentMustBeLessThanDue);
        return false;
      }
    }

    final validationError = Validators.validateAmount(
      paymentAmountController.text,
      totalDue,
    );
    if (validationError != null) {
      AppToast.error(validationError);
      return false;
    }

    final amountToPay = double.parse(paymentAmountController.text.trim());
    final tenant = _activeBedForPayment!.tenant;

    _isSubmittingPayment = true;
    notifyListeners();

    try {
      // Map payment option to DB standard (cash, online, card, bank_transfer, cheque)
      String apiMethod = 'cash';
      if (_selectedPaymentOption == AppStrings.paymentOptionCard) {
        apiMethod = 'card';
      } else if (_selectedPaymentOption == AppStrings.paymentOptionCheque) {
        apiMethod = 'cheque';
      } else if (_selectedPaymentOption == AppStrings.paymentOptionBankTransfer ||
          _selectedPaymentOption == AppStrings.paymentOptionNetBanking) {
        apiMethod = 'bank_transfer';
      } else if (_selectedPaymentOption == AppStrings.paymentOptionUPI ||
          _selectedPaymentOption == 'UPI') {
        apiMethod = 'online';
      } else {
        apiMethod = 'cash';
      }

      final userId = tenant?.userId ??
          int.tryParse(tenant?.id ?? '') ??
          42;

      final res = await _repository.collectPayment(
        userId: userId,
        paymentId: tenant?.paymentId,
        amountPaid: amountToPay,
        paymentMethod: apiMethod,
        paymentType: _paymentType == AppStrings.fullPayment ? 'full' : 'partial',
      );

      _isSubmittingPayment = false;
      _activeBedForPayment = null;
      _activeRoomNumberForPayment = null;
      paymentAmountController.text = '';

      // Reload live dashboard
      await loadData();

      final msg = res['msg']?.toString() ?? AppStrings.paymentSuccess;
      AppToast.success(msg);
      return true;
    } catch (e) {
      _isSubmittingPayment = false;
      notifyListeners();

      if (e is ApiException) {
        if (e.message.contains('Duplicate transaction request')) {
          AppToast.error('Duplicate payment detected. Please wait 30 seconds before retrying.');
        } else {
          AppToast.error(e.message);
        }
      } else {
        AppToast.error('Failed to process payment');
      }
      return false;
    }
  }

  @override
  void dispose() {
    paymentAmountController.dispose();
    super.dispose();
  }
}
