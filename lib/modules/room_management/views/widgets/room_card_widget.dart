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

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  Widget _buildMetricItem({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            amount,
            style: AppTextStyles.titleSmall.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
          // Header: Room Number and Occupancy Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Room ${room.roomNumber}',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${room.occupiedBeds}/${room.totalBeds} Beds',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Financial Summary Strip (Total, Paid, Remaining)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    label: 'Total',
                    amount: _formatCurrency(room.totalAmount),
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 26,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _buildMetricItem(
                    label: 'Paid',
                    amount: _formatCurrency(room.paidAmount),
                    color: AppColors.success,
                  ),
                ),
                Container(
                  width: 1,
                  height: 26,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _buildMetricItem(
                    label: 'Remaining',
                    amount: _formatCurrency(room.remainingAmount),
                    color: room.remainingAmount > 0 ? const Color(0xFFDC2626) : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.borderLight, height: 16),
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
