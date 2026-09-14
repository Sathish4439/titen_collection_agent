/// Transaction Model matching Titanstay API Section 2.5
class TransactionModel {
  final int transactionId;
  final int paymentId;
  final int userId;
  final double amountPaid;
  final String paymentMethod;
  final String transactionReference;
  final String createdAt;
  final String createdTime;
  final String dateGroup;
  final bool isToday;
  final String tenantName;
  final String blockName;
  final String roomNumber;

  const TransactionModel({
    required this.transactionId,
    required this.paymentId,
    required this.userId,
    required this.amountPaid,
    required this.paymentMethod,
    required this.transactionReference,
    required this.createdAt,
    required this.createdTime,
    required this.dateGroup,
    required this.isToday,
    required this.tenantName,
    required this.blockName,
    required this.roomNumber,
  });

  /// Derives initials from tenant name (e.g., "Ananya Rao" -> "AR")
  String get tenantInitials {
    final parts = tenantName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'TX';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Formatted amount string (e.g. "₹ 12,000" or "₹ 7,500")
  String get formattedAmount {
    final isWhole = amountPaid == amountPaid.truncateToDouble();
    final numStr = isWhole
        ? amountPaid.toInt().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )
        : amountPaid.toStringAsFixed(2);
    return '₹ $numStr';
  }

  /// User-friendly label matching dropdown options (Cash, UPI, Card, Net Banking)
  String get displayPaymentMethod {
    final m = paymentMethod.toLowerCase().trim().replaceAll(' ', '_');
    if (m == 'cash') return 'Cash';
    if (m == 'online' || m == 'upi') return 'UPI';
    if (m == 'card') return 'Card';
    if (m == 'bank_transfer' || m == 'net_banking') return 'Net Banking';
    if (m == 'cheque') return 'Cheque';
    return paymentMethod.isNotEmpty
        ? '${paymentMethod[0].toUpperCase()}${paymentMethod.substring(1)}'
        : 'Cash';
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transaction_id'] as int? ?? 0,
      paymentId: json['payment_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      amountPaid: double.tryParse(json['amount_paid']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
      transactionReference: json['transaction_reference'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      createdTime: json['created_time'] as String? ?? '',
      dateGroup: json['date_group'] as String? ?? 'Today',
      isToday: json['is_today'] as bool? ?? false,
      tenantName: json['tenant_name'] as String? ?? 'Tenant',
      blockName: json['block_name'] as String? ?? '',
      roomNumber: json['room_number'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'payment_id': paymentId,
      'user_id': userId,
      'amount_paid': amountPaid.toStringAsFixed(2),
      'payment_method': paymentMethod,
      'transaction_reference': transactionReference,
      'created_at': createdAt,
      'created_time': createdTime,
      'date_group': dateGroup,
      'is_today': isToday,
      'tenant_name': tenantName,
      'block_name': blockName,
      'room_number': roomNumber,
    };
  }
}

/// Collection History Metrics Model
class HistoryMetricsModel {
  final double totalCollected;
  final double cashCollected;
  final double onlineCollected;
  final int transactionCount;
  final Map<String, double> channelTotals;

  const HistoryMetricsModel({
    required this.totalCollected,
    required this.cashCollected,
    required this.onlineCollected,
    required this.transactionCount,
    required this.channelTotals,
  });

  factory HistoryMetricsModel.empty() {
    return const HistoryMetricsModel(
      totalCollected: 0,
      cashCollected: 0,
      onlineCollected: 0,
      transactionCount: 0,
      channelTotals: {
        'all': 0,
        'cash': 0,
        'upi': 0,
        'card': 0,
        'bank_transfer': 0,
        'cheque': 0,
      },
    );
  }

  factory HistoryMetricsModel.fromJson(Map<String, dynamic> json) {
    final rawTotals = json['channel_totals'] as Map<String, dynamic>? ?? {};
    final totals = <String, double>{};
    rawTotals.forEach((key, val) {
      totals[key] = double.tryParse(val?.toString() ?? '0') ?? 0.0;
    });

    return HistoryMetricsModel(
      totalCollected: double.tryParse(json['total_collected']?.toString() ?? '0') ?? 0.0,
      cashCollected: double.tryParse(json['cash_collected']?.toString() ?? '0') ?? 0.0,
      onlineCollected: double.tryParse(json['online_collected']?.toString() ?? '0') ?? 0.0,
      transactionCount: json['transaction_count'] as int? ?? 0,
      channelTotals: totals,
    );
  }

  /// Formatted total collected string
  String get formattedTotal {
    final isWhole = totalCollected == totalCollected.truncateToDouble();
    final numStr = isWhole
        ? totalCollected.toInt().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )
        : totalCollected.toStringAsFixed(2);
    return '₹$numStr';
  }

  /// Get formatted total for a specific channel key
  String formattedChannelAmount(String key) {
    final val = channelTotals[key.toLowerCase()] ?? 0.0;
    final isWhole = val == val.truncateToDouble();
    final numStr = isWhole
        ? val.toInt().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )
        : val.toStringAsFixed(2);
    return '₹$numStr';
  }
}
