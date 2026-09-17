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

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthNames[date.month - 1]} ${date.year}';
  }

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
    return Selector<CollectionHistoryViewModel, DateTime?>(
      selector: (_, vm) => vm.selectedDate,
      builder: (context, selectedDate, _) {
        final hasDate = selectedDate != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    width: 48.h,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: hasDate ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: hasDate ? AppColors.primary : AppColors.border,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 20.sp,
                      color: hasDate ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (hasDate) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Filtered: ${_formatDate(selectedDate)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () => context.read<CollectionHistoryViewModel>().clearDateFilter(),
                      child: Icon(
                        Icons.cancel,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
