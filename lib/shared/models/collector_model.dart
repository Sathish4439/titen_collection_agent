/// Collector Profile Model
class CollectorModel {
  final int collectorId;
  final String adminId;
  final String? tenantId;
  final String name;
  final String phone;
  final String? email;
  final List<String> assignedAdmins;
  final List<int>? assignedBlocks;
  final List<int>? assignedRooms;

  const CollectorModel({
    required this.collectorId,
    required this.adminId,
    this.tenantId,
    required this.name,
    required this.phone,
    this.email,
    this.assignedAdmins = const [],
    this.assignedBlocks,
    this.assignedRooms,
  });

  factory CollectorModel.fromJson(Map<String, dynamic> json) {
    final rawAdmins = json['assigned_admins'] as List<dynamic>?;
    final admins = rawAdmins?.map((e) => e.toString()).toList() ?? const [];

    final rawBlocks = json['assigned_blocks'] as List<dynamic>?;
    final blocks = rawBlocks?.map((e) => int.tryParse(e.toString()) ?? 0).toList();

    final rawRooms = json['assigned_rooms'] as List<dynamic>?;
    final rooms = rawRooms?.map((e) => int.tryParse(e.toString()) ?? 0).toList();

    return CollectorModel(
      collectorId: json['collector_id'] as int? ?? 0,
      adminId: json['admin_id'] as String? ?? '',
      tenantId: json['tenant_id'] as String?,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      assignedAdmins: admins,
      assignedBlocks: blocks,
      assignedRooms: rooms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collector_id': collectorId,
      'admin_id': adminId,
      'tenant_id': tenantId,
      'name': name,
      'phone': phone,
      'email': email,
      'assigned_admins': assignedAdmins,
      'assigned_blocks': assignedBlocks,
      'assigned_rooms': assignedRooms,
    };
  }
}
