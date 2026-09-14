import 'package:flutter/material.dart';
import 'package:collection_agent/shared/models/transaction_model.dart';
import 'package:collection_agent/shared/repositories/collector_repository.dart';

/// ViewModel managing state and filtering for the Collection History Screen
class CollectionHistoryViewModel extends ChangeNotifier {
  final CollectorRepository _repository = CollectorRepository.instance;

  String _selectedFilter = 'all';
  String _searchQuery = '';
  DateTime? _selectedDate;
  bool _isLoading = false;

  HistoryMetricsModel _metrics = HistoryMetricsModel.empty();
  List<TransactionModel> _transactions = [];

  CollectionHistoryViewModel() {
    fetchHistory();
  }

  // Getters
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  DateTime? get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  HistoryMetricsModel get metrics => _metrics;
  List<TransactionModel> get transactions => _transactions;

  /// Filtered list of transactions based on selected channel chip, search query, and date
  List<TransactionModel> get filteredTransactions {
    return _transactions.where((tx) {
      // 1. Channel Filter
      if (_selectedFilter != 'all') {
        final normMethod = tx.paymentMethod.toLowerCase().replaceAll(' ', '_');
        final normFilter = _selectedFilter.toLowerCase().replaceAll(' ', '_');
        if (normMethod != normFilter && !normMethod.contains(normFilter)) {
          return false;
        }
      }

      // 2. Search Query Filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesName = tx.tenantName.toLowerCase().contains(query);
        final matchesRoom = tx.roomNumber.toLowerCase().contains(query);
        final matchesMethod = tx.paymentMethod.toLowerCase().contains(query);
        final matchesRef = tx.transactionReference.toLowerCase().contains(query);
        if (!matchesName && !matchesRoom && !matchesMethod && !matchesRef) {
          return false;
        }
      }

      // 3. Date Filter (if specific date picked)
      if (_selectedDate != null) {
        final datePrefix =
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
        if (!tx.createdAt.startsWith(datePrefix) && !tx.isToday) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Groups transactions by dateGroup (e.g. "TODAY", "YESTERDAY", etc.)
  Map<String, List<TransactionModel>> get groupedTransactions {
    final map = <String, List<TransactionModel>>{};
    for (final tx in filteredTransactions) {
      final key = tx.dateGroup.toUpperCase();
      map.putIfAbsent(key, () => []).add(tx);
    }
    return map;
  }

  /// Fetches real collection history from backend API with fallback
  Future<void> fetchHistory({bool isRefresh = false}) async {
    if (!isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      String? dateParam;
      if (_selectedDate != null) {
        dateParam =
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      }

      final result = await _repository.getCollectionHistory(
        date: dateParam,
        paymentMethod: _selectedFilter != 'all' ? _selectedFilter : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      _metrics = result.metrics;
      _transactions = result.transactions;
    } catch (e) {
      // If network fails, use mock data as fallback
      _initMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Setters & Actions
  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
      fetchHistory();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
    fetchHistory();
  }

  void clearDateFilter() {
    _selectedDate = null;
    notifyListeners();
    fetchHistory();
  }

  void _initMockData() {
    _transactions = [
      const TransactionModel(
        transactionId: 881,
        paymentId: 201,
        userId: 42,
        amountPaid: 7500.0,
        paymentMethod: 'Cash',
        transactionReference: 'COL-CASH-991823',
        createdAt: '2026-09-13T14:30:00.000Z',
        createdTime: '02:30 PM',
        dateGroup: 'Today',
        isToday: true,
        tenantName: 'John Doe',
        blockName: 'Block A',
        roomNumber: '101',
      ),
      const TransactionModel(
        transactionId: 882,
        paymentId: 202,
        userId: 43,
        amountPaid: 7500.0,
        paymentMethod: 'UPI',
        transactionReference: 'COL-UPI-991824',
        createdAt: '2026-09-13T15:15:00.000Z',
        createdTime: '03:15 PM',
        dateGroup: 'Today',
        isToday: true,
        tenantName: 'Ananya Rao',
        blockName: 'Block A',
        roomNumber: '101',
      ),
    ];

    _recomputeMetrics();
  }

  void _recomputeMetrics() {
    double total = 0;
    double cash = 0;
    double online = 0;
    final channelTotals = <String, double>{
      'all': 0,
      'cash': 0,
      'upi': 0,
      'card': 0,
      'bank_transfer': 0,
      'cheque': 0,
    };

    for (final tx in _transactions) {
      total += tx.amountPaid;
      final methodKey = tx.paymentMethod.toLowerCase().replaceAll(' ', '_');
      channelTotals[methodKey] = (channelTotals[methodKey] ?? 0.0) + tx.amountPaid;

      if (methodKey == 'cash') {
        cash += tx.amountPaid;
      } else {
        online += tx.amountPaid;
      }
    }
    channelTotals['all'] = total;

    _metrics = HistoryMetricsModel(
      totalCollected: total,
      cashCollected: cash,
      onlineCollected: online,
      transactionCount: _transactions.length,
      channelTotals: channelTotals,
    );
  }
}
