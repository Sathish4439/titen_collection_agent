import 'dart:convert';
import 'package:collection_agent/core/network/api_client.dart';
import 'package:collection_agent/core/network/api_endpoints.dart';
import 'package:collection_agent/core/storage/secure_storage.dart';
import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/block_model.dart';
import 'package:collection_agent/shared/models/collector_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';
import 'package:collection_agent/shared/models/transaction_model.dart';

/// Central Repository integrating Titanstay Collector API
class CollectorRepository {
  CollectorRepository._();

  static final CollectorRepository instance = CollectorRepository._();

  final ApiClient _client = ApiClient.instance;

  /// 2.1 Login / Passcode Verification
  Future<CollectorModel> loginWithPasscode({
    required String phone,
    required String passcode,
    String? tenantId,
  }) async {
    if (tenantId != null && tenantId.isNotEmpty) {
      _client.setTenantId(tenantId);
      await SecureStorage.instance.write(ApiClient.keyTenantId, tenantId);
    }

    final response = await _client.post(
      ApiEndpoints.verifyOtp,
      body: {
        'phone': phone.trim(),
        'passcode': passcode.trim(),
      },
      requiresAuth: false,
    );

    final token = response['token'] as String?;
    if (token != null) {
      await SecureStorage.instance.write(ApiClient.keyToken, token);
    }

    final collectorJson = response['collector'] as Map<String, dynamic>? ??
        response['data'] as Map<String, dynamic>? ??
        {};

    final collector = CollectorModel.fromJson(collectorJson);
    await SecureStorage.instance.write(
      ApiClient.keyCollectorProfile,
      jsonEncode(collector.toJson()),
    );

    return collector;
  }

  /// Logout collector and clear session credentials
  Future<void> logout() async {
    await SecureStorage.instance.delete(ApiClient.keyToken);
    await SecureStorage.instance.delete(ApiClient.keyCollectorProfile);
  }

  /// Get cached collector profile from local storage
  Future<CollectorModel?> getCachedCollector() async {
    final raw = await SecureStorage.instance.read(ApiClient.keyCollectorProfile);
    if (raw != null && raw.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(raw);
        return CollectorModel.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// 2.2 Get Agent Profile & Scope
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _client.get(ApiEndpoints.me);
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  /// 2.3 Get Agent Dashboard & Room Tree
  Future<DashboardData> getDashboard({
    String? search,
    int? blockId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (blockId != null) {
      queryParams['block_id'] = blockId;
    }

    final response = await _client.get(
      ApiEndpoints.dashboard,
      queryParameters: queryParams,
    );

    final data = response['data'] as Map<String, dynamic>? ?? {};
    final metricsJson = data['metrics'] as Map<String, dynamic>? ?? {};
    final rawBlocks = data['blocks'] as List<dynamic>? ?? [];

    final blocks = <BlockModel>[];
    final allRooms = <RoomModel>[];

    for (final bJson in rawBlocks) {
      final bMap = bJson as Map<String, dynamic>;
      final bId = bMap['block_id']?.toString() ?? '';
      final bName = bMap['block_name']?.toString() ?? 'Block';
      final roomsList = bMap['rooms'] as List<dynamic>? ?? [];

      int blockTotalBeds = 0;
      int blockOccupiedBeds = 0;

      for (final rJson in roomsList) {
        final rMap = rJson as Map<String, dynamic>;
        final rId = rMap['room_id']?.toString() ?? '';
        final rNumber = rMap['room_number']?.toString() ?? '';
        final capacity = (rMap['capacity'] as num?)?.toInt() ?? 2;
        final rawTenants = rMap['tenants'] as List<dynamic>? ?? [];

        final beds = <BedModel>[];

        // Create bed entries for each tenant
        for (int i = 0; i < rawTenants.length; i++) {
          final tMap = rawTenants[i] as Map<String, dynamic>;
          final tenant = TenantModel.fromJson({
            ...tMap,
            'block_name': bName,
            'room_number': rNumber,
          });

          beds.add(BedModel(
            id: 'bed-$rId-${i + 1}',
            bedNumber: i + 1,
            tenant: tenant,
            amountDue: tenant.balancePayable > 0
                ? tenant.balancePayable
                : (tenant.isPaid ? 0.0 : tenant.amountDue),
            isPaid: tenant.isPaid,
          ));
        }

        blockTotalBeds += capacity;
        blockOccupiedBeds += beds.length;

        if (beds.isNotEmpty) {
          allRooms.add(RoomModel(
            id: rId,
            roomNumber: rNumber,
            blockId: bId,
            beds: beds,
          ));
        }
      }

      blocks.add(BlockModel(
        id: bId,
        name: bName,
        totalRooms: roomsList.length,
        totalBeds: blockTotalBeds,
        occupiedBeds: blockOccupiedBeds,
      ));
    }

    return DashboardData(
      totalRooms: (metricsJson['total_rooms'] as num?)?.toInt() ?? allRooms.length,
      todayCollected: double.tryParse(metricsJson['today_collected']?.toString() ?? '0') ?? 0.0,
      blocks: blocks,
      rooms: allRooms,
    );
  }

  /// 2.4 Collect Rent Payment
  Future<Map<String, dynamic>> collectPayment({
    required int userId,
    int? paymentId,
    required double amountPaid,
    required String paymentMethod,
    String paymentType = 'full',
    String? transactionReference,
  }) async {
    final body = <String, dynamic>{
      'user_id': userId,
      'payment_id': ?paymentId,
      'amount_paid': amountPaid,
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      if (transactionReference != null && transactionReference.isNotEmpty)
        'transaction_reference': transactionReference,
    };

    final response = await _client.post(
      ApiEndpoints.collectPayment,
      body: body,
    );

    return response['data'] as Map<String, dynamic>? ?? {};
  }

  /// 2.5 Get Agent Collection History
  Future<HistoryData> getCollectionHistory({
    String? date,
    String? paymentMethod,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }
    if (paymentMethod != null && paymentMethod.toLowerCase() != 'all') {
      queryParams['payment_method'] = paymentMethod;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await _client.get(
      ApiEndpoints.paymentHistory,
      queryParameters: queryParams,
    );

    final data = response['data'] as Map<String, dynamic>? ?? {};
    final metricsJson = data['metrics'] as Map<String, dynamic>? ?? {};
    final rawTx = data['transactions'] as List<dynamic>? ?? [];

    final transactions = rawTx
        .map((t) => TransactionModel.fromJson(t as Map<String, dynamic>))
        .toList();

    final metrics = HistoryMetricsModel.fromJson(metricsJson);

    return HistoryData(
      metrics: metrics,
      transactions: transactions,
    );
  }

  /// Customer Details Drawer / Bottom Sheet
  Future<TenantModel?> getCustomerDetails(int userId) async {
    try {
      final response = await _client.get('${ApiEndpoints.customerDetails}/$userId');
      final data = response['data'] as Map<String, dynamic>?;
      if (data != null) {
        return TenantModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }
}

/// Dashboard Result Wrapper
class DashboardData {
  final int totalRooms;
  final double todayCollected;
  final List<BlockModel> blocks;
  final List<RoomModel> rooms;

  const DashboardData({
    required this.totalRooms,
    required this.todayCollected,
    required this.blocks,
    required this.rooms,
  });
}

/// History Result Wrapper
class HistoryData {
  final HistoryMetricsModel metrics;
  final List<TransactionModel> transactions;

  const HistoryData({
    required this.metrics,
    required this.transactions,
  });
}
