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
    this.paymentId,
    this.paymentStatus = 'due',
    this.amountDue = 0.0,
    this.rentPaidAmount = 0.0,
    this.balancePayable = 0.0,
    this.dueDate = '',
    this.paymentCycleStartDate = '',
  });

  bool get isPaid => paymentStatus.toLowerCase() == 'paid' || (amountDue > 0 && rentPaidAmount >= amountDue);

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

    return TenantModel(
      id: (json['id'] ?? parsedUserId?.toString() ?? '').toString(),
      userId: parsedUserId,
      customerId: (json['customer_id'] ?? json['customerId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      dob: (json['dob'] ?? '').toString(),
      joiningDate: (json['joining_date'] ?? json['joiningDate'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      idProofs: (json['idProofs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      emergencyContact1: (json['emergencyContact1'] ?? json['emergency_number_one'] ?? '').toString(),
      emergencyContact2: (json['emergencyContact2'] ?? json['emergency_number_two'] ?? '').toString(),
      roomNumber: (json['room_number'] ?? json['roomNumber'] ?? '').toString(),
      blockName: (json['block_name'] ?? json['blockName'] ?? '').toString(),
      status: (json['status'] ?? 'Active').toString(),
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
      'emergencyContact1': emergencyContact1,
      'emergencyContact2': emergencyContact2,
      'room_number': roomNumber,
      'block_name': blockName,
      'status': status,
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
