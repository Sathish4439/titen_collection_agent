/// Tenant Domain Model with Manual JSON serialization
class TenantModel {
  final String id;
  final String customerId;
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String joiningDate;
  final String gender;
  final List<String> idProofs;
  final String emergencyContact1;
  final String emergencyContact2;
  final String roomNumber;
  final String blockName;
  final String status;

  const TenantModel({
    required this.id,
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.joiningDate,
    required this.gender,
    required this.idProofs,
    required this.emergencyContact1,
    required this.emergencyContact2,
    required this.roomNumber,
    required this.blockName,
    required this.status,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'NA';
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      joiningDate: json['joiningDate'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      idProofs: (json['idProofs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      emergencyContact1: json['emergencyContact1'] as String? ?? '',
      emergencyContact2: json['emergencyContact2'] as String? ?? '',
      roomNumber: json['roomNumber'] as String? ?? '',
      blockName: json['blockName'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'joiningDate': joiningDate,
      'gender': gender,
      'idProofs': idProofs,
      'emergencyContact1': emergencyContact1,
      'emergencyContact2': emergencyContact2,
      'roomNumber': roomNumber,
      'blockName': blockName,
      'status': status,
    };
  }

  TenantModel copyWith({
    String? id,
    String? customerId,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? joiningDate,
    String? gender,
    List<String>? idProofs,
    String? emergencyContact1,
    String? emergencyContact2,
    String? roomNumber,
    String? blockName,
    String? status,
  }) {
    return TenantModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      joiningDate: joiningDate ?? this.joiningDate,
      gender: gender ?? this.gender,
      idProofs: idProofs ?? this.idProofs,
      emergencyContact1: emergencyContact1 ?? this.emergencyContact1,
      emergencyContact2: emergencyContact2 ?? this.emergencyContact2,
      roomNumber: roomNumber ?? this.roomNumber,
      blockName: blockName ?? this.blockName,
      status: status ?? this.status,
    );
  }
}
