import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';

/// Block Filter Dropdown Button matching Screen 2
class BlockFilterDropdown extends StatelessWidget {
  const BlockFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RoomManagementViewModel, String>(
      selector: (_, vm) => vm.selectedBlockId,
      builder: (context, selectedId, _) {
        final vm = context.read<RoomManagementViewModel>();

        return PopupMenuButton<String>(
          onSelected: (blockId) {
            vm.filterBlock(blockId);
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<String>(
                value: 'ALL',
                child: Text(AppStrings.allBlocks),
              ),
              ...vm.blocks.map(
                (b) => PopupMenuItem<String>(
                  value: b.id,
                  child: Text(b.name),
                ),
              ),
            ];
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedId == 'ALL'
                      ? AppStrings.allBlocks
                      : vm.blocks.firstWhere((b) => b.id == selectedId, orElse: () => vm.blocks.first).name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
