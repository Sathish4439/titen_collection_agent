import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/collection_history/viewmodel/collection_history_viewmodel.dart';
import 'package:collection_agent/shared/models/transaction_model.dart';

class _ChannelItem {
  final String key;
  final String label;
  final IconData icon;

  const _ChannelItem({
    required this.key,
    required this.label,
    required this.icon,
  });
}

/// Payment Channels section with header and horizontal scrollable filter chips
class PaymentChannelChips extends StatelessWidget {
  const PaymentChannelChips({super.key});

  static const List<_ChannelItem> _channels = [
    _ChannelItem(
      key: 'all',
      label: AppStrings.channelAll,
      icon: Icons.grid_view_rounded,
    ),
    _ChannelItem(
      key: 'cash',
      label: AppStrings.channelCash,
      icon: Icons.payments_outlined,
    ),
    _ChannelItem(
      key: 'upi',
      label: AppStrings.channelUpi,
      icon: Icons.qr_code_2_rounded,
    ),
    _ChannelItem(
      key: 'card',
      label: AppStrings.channelCard,
      icon: Icons.credit_card_rounded,
    ),
    _ChannelItem(
      key: 'bank_transfer',
      label: AppStrings.channelBankTransfer,
      icon: Icons.account_balance_outlined,
    ),
    _ChannelItem(
      key: 'cheque',
      label: AppStrings.channelCheque,
      icon: Icons.receipt_long_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.paymentChannels,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Selector<CollectionHistoryViewModel, String>(
              selector: (_, vm) => vm.selectedFilter,
              builder: (context, selectedFilter, _) {
                final isAll = selectedFilter == 'all';
                return InkWell(
                  onTap: () {
                    context.read<CollectionHistoryViewModel>().setFilter('all');
                  },
                  child: Text(
                    isAll ? AppStrings.showingAll : 'Show All',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Horizontal Scrollable Chips
        SizedBox(
          height: 42.h,
          child: Selector<CollectionHistoryViewModel, (String, HistoryMetricsModel)>(
            selector: (_, vm) => (vm.selectedFilter, vm.metrics),
            builder: (context, data, _) {
              final selectedFilter = data.$1;
              final metrics = data.$2;

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _channels.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final channel = _channels[index];
                  final isSelected = selectedFilter == channel.key;
                  final amountStr = metrics.formattedChannelAmount(channel.key);

                  return _buildChip(
                    context: context,
                    channel: channel,
                    isSelected: isSelected,
                    amountStr: amountStr,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required _ChannelItem channel,
    required bool isSelected,
    required String amountStr,
  }) {
    return InkWell(
      onTap: () {
        context.read<CollectionHistoryViewModel>().setFilter(channel.key);
      },
      borderRadius: BorderRadius.circular(24.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipActiveBg : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isSelected
              ? null
              : Border.all(color: AppColors.chipInactiveBorder, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              channel.icon,
              size: 16.sp,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            SizedBox(width: 6.w),
            Text(
              channel.label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.chipInactiveBadgeBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                amountStr,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
