import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';

/// Block Header with Metadata summary matching Screen 2
class BlockHeaderWidget extends StatelessWidget {
  const BlockHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RoomManagementViewModel, String>(
      selector: (_, vm) => '${vm.currentBlockName}|${vm.currentBlockSummary}',
      builder: (context, combined, _) {
        final parts = combined.split('|');
        final blockName = parts[0];
        final blockSummary = parts.length > 1 ? parts[1] : '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blockName,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              blockSummary,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
