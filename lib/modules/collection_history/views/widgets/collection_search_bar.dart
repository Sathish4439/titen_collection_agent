import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/collection_history/viewmodel/collection_history_viewmodel.dart';

/// Search input bar with attached Date Picker action button
class CollectionSearchBar extends StatelessWidget {
  const CollectionSearchBar({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final vm = context.read<CollectionHistoryViewModel>();
    final initialDate = vm.selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      vm.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Input Box
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.searchFieldBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20.sp,
                  color: AppColors.textMuted,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        context.read<CollectionHistoryViewModel>().setSearchQuery(val),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.searchTransactionsHint,
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Calendar Date Picker Button
        Selector<CollectionHistoryViewModel, DateTime?>(
          selector: (_, vm) => vm.selectedDate,
          builder: (context, selectedDate, _) {
            final hasDate = selectedDate != null;
            return InkWell(
              onTap: () {
                if (hasDate) {
                  context.read<CollectionHistoryViewModel>().clearDateFilter();
                } else {
                  _pickDate(context);
                }
              },
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                width: 48.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: hasDate ? AppColors.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: hasDate ? AppColors.primary : AppColors.border,
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  hasDate ? Icons.close_rounded : Icons.calendar_today_outlined,
                  size: 20.sp,
                  color: hasDate ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
