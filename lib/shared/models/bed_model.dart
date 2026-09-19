import 'package:collection_agent/shared/models/tenant_model.dart';

/// Bed Domain Model
class BedModel {
  final String id;
  final int bedNumber;
  final TenantModel? tenant;
  final double amountDue;
  final bool isPaid;

  const BedModel({
    required this.id,
    required this.bedNumber,
    this.tenant,
    required this.amountDue,
    required this.isPaid,
  });

  bool get isVacant => tenant == null;
  double get totalAmount => tenant?.amountDue ?? amountDue;
  double get paidAmount => tenant?.rentPaidAmount ?? 0.0;
  double get remainingAmount => tenant?.balancePayable ?? (isPaid ? 0.0 : amountDue);

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: json['id'] as String? ?? '',
      bedNumber: json['bedNumber'] as int? ?? 1,
      tenant: json['tenant'] != null
          ? TenantModel.fromJson(json['tenant'] as Map<String, dynamic>)
          : null,
      amountDue: (json['amountDue'] as num?)?.toDouble() ?? 0.0,
      isPaid: json['isPaid'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bedNumber': bedNumber,
      'tenant': tenant?.toJson(),
      'amountDue': amountDue,
      'isPaid': isPaid,
    };
  }

  BedModel copyWith({
    String? id,
    int? bedNumber,
    TenantModel? tenant,
    double? amountDue,
    bool? isPaid,
  }) {
    return BedModel(
      id: id ?? this.id,
      bedNumber: bedNumber ?? this.bedNumber,
      tenant: tenant ?? this.tenant,
      amountDue: amountDue ?? this.amountDue,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
