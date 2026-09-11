import 'package:flutter/material.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/views/widgets/tenant_row_widget.dart';
import 'package:collection_agent/shared/models/bed_model.dart';
import 'package:collection_agent/shared/models/room_model.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';

/// Room Card Widget matching Screen 2
class RoomCardWidget extends StatelessWidget {
  final RoomModel room;
  final void Function(RoomModel room, BedModel bed) onPayTap;
  final void Function(TenantModel tenant) onTenantTap;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.onPayTap,
    required this.onTenantTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.roomNumber,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...room.beds.map((bed) {
            return TenantRowWidget(
              room: room,
              bed: bed,
              onPayTap: () => onPayTap(room, bed),
              onDetailsTap: () {
                if (bed.tenant != null) {
                  onTenantTap(bed.tenant!);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
