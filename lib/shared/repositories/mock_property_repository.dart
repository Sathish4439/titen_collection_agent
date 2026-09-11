import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/block_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';

/// Singleton In-Memory Property Repository
/// Accurately populates data from the 4 design screens
class MockPropertyRepository {
  MockPropertyRepository._() {
    _initializeData();
  }

  static final MockPropertyRepository instance = MockPropertyRepository._();

  List<BlockModel> _blocks = [];
  List<RoomModel> _rooms = [];

  void _initializeData() {
    final tenantDivya = const TenantModel(
      id: 'tenant-1',
      customerId: 'PG147',
      name: 'divya',
      email: 'divya@in.com',
      phone: '9894269408',
      dob: '24 August, 2010',
      joiningDate: '27 August, 2026',
      gender: 'female',
      idProofs: [
        '178798948181-708679548.pdf',
        '178798948232-249643495.pdf',
      ],
      emergencyContact1: '099875251629 (0393722220)',
      emergencyContact2: '3333333339 (222222228)',
      roomNumber: '101',
      blockName: 'A-Block',
      status: 'Active',
    );

    final tenantAnanya = const TenantModel(
      id: 'tenant-2',
      customerId: 'PG148',
      name: 'Ananya Rao',
      email: 'ananya.rao@example.com',
      phone: '9845012345',
      dob: '15 May, 1998',
      joiningDate: '01 June, 2026',
      gender: 'female',
      idProofs: [
        'aadhar_ananya_rao.pdf',
      ],
      emergencyContact1: '9845099999 (Father)',
      emergencyContact2: '9845088888 (Mother)',
      roomNumber: '101',
      blockName: 'A-Block',
      status: 'Active',
    );

    // Room 101: 3 Beds
    final room101 = RoomModel(
      id: 'room-101',
      roomNumber: '101',
      blockId: 'block-a',
      beds: [
        BedModel(
          id: 'bed-101-1',
          bedNumber: 1,
          tenant: tenantAnanya,
          amountDue: 12000.0,
          isPaid: false,
        ),
        BedModel(
          id: 'bed-101-2',
          bedNumber: 2,
          tenant: tenantAnanya,
          amountDue: 1000.0,
          isPaid: false,
        ),
        BedModel(
          id: 'bed-101-3',
          bedNumber: 3,
          tenant: tenantDivya,
          amountDue: 2000.0,
          isPaid: false,
        ),
      ],
    );

    // Room 102: 3 Beds (1 vacant to match 5/6 occupied in A-Block)
    final room102 = RoomModel(
      id: 'room-102',
      roomNumber: '102',
      blockId: 'block-a',
      beds: [
        BedModel(
          id: 'bed-102-1',
          bedNumber: 1,
          tenant: tenantAnanya,
          amountDue: 12000.0,
          isPaid: true, // Shows green PAID in Screen 2
        ),
        BedModel(
          id: 'bed-102-2',
          bedNumber: 2,
          tenant: tenantAnanya,
          amountDue: 1000.0,
          isPaid: false,
        ),
        BedModel(
          id: 'bed-102-3',
          bedNumber: 3,
          tenant: tenantAnanya,
          amountDue: 2000.0,
          isPaid: false,
        ),
      ],
    );

    _blocks = [
      const BlockModel(
        id: 'block-a',
        name: 'A-Block',
        totalRooms: 3,
        totalBeds: 6,
        occupiedBeds: 5, // 1 vacant (matches design 5/6)
      ),
      const BlockModel(
        id: 'block-b',
        name: 'B-Block',
        totalRooms: 4,
        totalBeds: 8,
        occupiedBeds: 7,
      ),
      const BlockModel(
        id: 'block-c',
        name: 'C-Block',
        totalRooms: 3,
        totalBeds: 8,
        occupiedBeds: 6,
      ),
    ];

    _rooms = [room101, room102];
  }

  List<BlockModel> getBlocks() {
    return List.unmodifiable(_blocks);
  }

  List<RoomModel> getRooms({String? blockId}) {
    if (blockId == null || blockId.isEmpty || blockId == 'ALL') {
      return List.unmodifiable(_rooms);
    }
    return List.unmodifiable(_rooms.where((r) => r.blockId == blockId));
  }

  int getTotalRooms() => 10; // Global KPI metric from design
  int getTotalBeds() => 22; // Global KPI metric from design

  bool recordPayment({
    required String bedId,
    required double amount,
    required String paymentOption,
  }) {
    bool updated = false;

    _rooms = _rooms.map((room) {
      final updatedBeds = room.beds.map((bed) {
        if (bed.id == bedId) {
          final newDue = (bed.amountDue - amount).clamp(0.0, double.infinity);
          final isNowPaid = newDue == 0.0;
          updated = true;
          return bed.copyWith(
            amountDue: newDue,
            isPaid: isNowPaid,
          );
        }
        return bed;
      }).toList();

      return room.copyWith(beds: updatedBeds);
    }).toList();

    return updated;
  }
}
