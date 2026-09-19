import 'package:collection_agent/shared/models/bed_model.dart';

/// Room Domain Model
class RoomModel {
  final String id;
  final String roomNumber;
  final String blockId;
  final List<BedModel> beds;

  const RoomModel({
    required this.id,
    required this.roomNumber,
    required this.blockId,
    required this.beds,
  });

  int get totalBeds => beds.length;
  int get occupiedBeds => beds.where((b) => !b.isVacant).length;
  int get vacantBeds => beds.where((b) => b.isVacant).length;

  double get totalAmount =>
      beds.fold(0.0, (sum, b) => sum + (b.tenant?.amountDue ?? 0.0));
  double get paidAmount =>
      beds.fold(0.0, (sum, b) => sum + (b.tenant?.rentPaidAmount ?? 0.0));
  double get remainingAmount =>
      beds.fold(0.0, (sum, b) => sum + (b.tenant?.balancePayable ?? (b.isPaid ? 0.0 : b.amountDue)));

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String? ?? '',
      roomNumber: json['roomNumber'] as String? ?? '',
      blockId: json['blockId'] as String? ?? '',
      beds: (json['beds'] as List<dynamic>?)
              ?.map((e) => BedModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomNumber': roomNumber,
      'blockId': blockId,
      'beds': beds.map((b) => b.toJson()).toList(),
    };
  }

  RoomModel copyWith({
    String? id,
    String? roomNumber,
    String? blockId,
    List<BedModel>? beds,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      blockId: blockId ?? this.blockId,
      beds: beds ?? this.beds,
    );
  }
}
