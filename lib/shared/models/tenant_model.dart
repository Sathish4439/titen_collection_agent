import 'dart:convert';

/// Tenant Domain Model with Manual JSON serialization
class TenantModel {
  final String id;
  final int? userId;
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
  final String? profileImageUrl;
  final String? bloodGroup;
  
  // Payment Integration Fields from Backend
  final int? paymentId;
  final String paymentStatus;
  final double amountDue;
  final double rentPaidAmount;
  final double balancePayable;
  final String dueDate;
  final String paymentCycleStartDate;

  const TenantModel({
    required this.id,
    this.userId,
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
    this.profileImageUrl,
    this.bloodGroup,
    this.paymentId,
    this.paymentStatus = 'due',
    this.amountDue = 0.0,
    this.rentPaidAmount = 0.0,
    this.balancePayable = 0.0,
    this.dueDate = '',
    this.paymentCycleStartDate = '',
  });

  bool get isPaid => paymentStatus.toLowerCase() == 'paid' || (amountDue <= 0 && balancePayable <= 0);

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
    final rawUserId = json['user_id'] ?? json['userId'];
    final parsedUserId = rawUserId != null ? int.tryParse(rawUserId.toString()) : null;

    final rawPaymentId = json['payment_id'] ?? json['paymentId'];
    final parsedPaymentId = rawPaymentId != null ? int.tryParse(rawPaymentId.toString()) : null;

    final parsedAmountDue = double.tryParse(json['amount_due']?.toString() ?? json['amountDue']?.toString() ?? '0') ?? 0.0;
    final parsedRentPaid = double.tryParse(json['rent_paid_amount']?.toString() ?? json['rentPaidAmount']?.toString() ?? '0') ?? 0.0;
    final parsedBalance = double.tryParse(json['balance_payable']?.toString() ?? json['balancePayable']?.toString() ?? '0') ?? parsedAmountDue;

    final rawIdProofs = json['id_proof_urls'] ?? json['idProofs'];
    final List<String> parsedIdProofs = () {
      if (rawIdProofs is List) {
        return rawIdProofs.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
      } else if (rawIdProofs is String && rawIdProofs.trim().isNotEmpty) {
        final str = rawIdProofs.trim();
        if (str.startsWith('[') && str.endsWith(']')) {
          try {
            final decoded = jsonDecode(str);
            if (decoded is List) {
              return decoded.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
            }
          } catch (_) {}
        }
        return [str];
      }
      return <String>[];
    }();

    String formatEmergencyContact(dynamic directVal, dynamic num, dynamic name, dynamic rel) {
      if (directVal != null && directVal.toString().trim().isNotEmpty) {
        return directVal.toString().trim();
      }
      final sNum = num?.toString().trim() ?? '';
      final sName = name?.toString().trim() ?? '';
      final sRel = rel?.toString().trim() ?? '';
      if (sNum.isEmpty && sName.isEmpty) return '';
      final details = [if (sName.isNotEmpty) sName, if (sRel.isNotEmpty) '($sRel)'].join(' ');
      if (details.isNotEmpty && sNum.isNotEmpty) {
        return '$sNum ($details)';
      }
      return sNum.isNotEmpty ? sNum : details;
    }

    final contact1 = formatEmergencyContact(
      json['emergencyContact1'],
      json['emergency_number_one'],
      json['emergency_name_one'],
      json['emergency_relation_one'],
    );

    final contact2 = formatEmergencyContact(
      json['emergencyContact2'],
      json['emergency_number_two'],
      json['emergency_name_two'],
      json['emergency_relation_two'],
    );

    return TenantModel(
      id: (json['id'] ?? parsedUserId?.toString() ?? '').toString(),
      userId: parsedUserId,
      customerId: (json['customer_id'] ?? json['customerId'] ?? '').toString(),
      name: (json['name'] ?? json['user_name'] ?? '').toString(),
      email: (json['email'] ?? json['user_email'] ?? '').toString(),
      phone: (json['phone'] ?? json['user_phone'] ?? '').toString(),
      dob: (json['dob'] ?? '').toString(),
      joiningDate: (json['joining_date'] ?? json['joiningDate'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      idProofs: parsedIdProofs,
      emergencyContact1: contact1,
      emergencyContact2: contact2,
      roomNumber: (json['room_number'] ?? json['roomNumber'] ?? '').toString(),
      blockName: (json['block_name'] ?? json['blockName'] ?? '').toString(),
      status: (json['status'] ?? 'Active').toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      paymentId: parsedPaymentId,
      paymentStatus: (json['payment_status'] ?? json['paymentStatus'] ?? 'due').toString(),
      amountDue: parsedAmountDue,
      rentPaidAmount: parsedRentPaid,
      balancePayable: parsedBalance,
      dueDate: (json['due_date'] ?? json['dueDate'] ?? '').toString(),
      paymentCycleStartDate: (json['payment_cycle_start_date'] ?? json['paymentCycleStartDate'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'customer_id': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'joining_date': joiningDate,
      'gender': gender,
      'idProofs': idProofs,
      'id_proof_urls': idProofs,
      'emergencyContact1': emergencyContact1,
      'emergencyContact2': emergencyContact2,
      'room_number': roomNumber,
      'block_name': blockName,
      'status': status,
      'profile_image_url': profileImageUrl,
      'blood_group': bloodGroup,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'amount_due': amountDue,
      'rent_paid_amount': rentPaidAmount,
      'balance_payable': balancePayable,
      'due_date': dueDate,
      'payment_cycle_start_date': paymentCycleStartDate,
    };
  }

  TenantModel copyWith({
    String? id,
    int? userId,
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
    String? profileImageUrl,
    String? bloodGroup,
    int? paymentId,
    String? paymentStatus,
    double? amountDue,
    double? rentPaidAmount,
    double? balancePayable,
    String? dueDate,
    String? paymentCycleStartDate,
  }) {
    return TenantModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      amountDue: amountDue ?? this.amountDue,
      rentPaidAmount: rentPaidAmount ?? this.rentPaidAmount,
      balancePayable: balancePayable ?? this.balancePayable,
      dueDate: dueDate ?? this.dueDate,
      paymentCycleStartDate: paymentCycleStartDate ?? this.paymentCycleStartDate,
    );
  }
}
