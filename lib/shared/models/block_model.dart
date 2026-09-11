/// Block Domain Model
class BlockModel {
  final String id;
  final String name;
  final int totalRooms;
  final int totalBeds;
  final int occupiedBeds;

  const BlockModel({
    required this.id,
    required this.name,
    required this.totalRooms,
    required this.totalBeds,
    required this.occupiedBeds,
  });

  int get vacantBeds => totalBeds - occupiedBeds;

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      totalRooms: json['totalRooms'] as int? ?? 0,
      totalBeds: json['totalBeds'] as int? ?? 0,
      occupiedBeds: json['occupiedBeds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalRooms': totalRooms,
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
    };
  }

  BlockModel copyWith({
    String? id,
    String? name,
    int? totalRooms,
    int? totalBeds,
    int? occupiedBeds,
  }) {
    return BlockModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalRooms: totalRooms ?? this.totalRooms,
      totalBeds: totalBeds ?? this.totalBeds,
      occupiedBeds: occupiedBeds ?? this.occupiedBeds,
    );
  }
}
