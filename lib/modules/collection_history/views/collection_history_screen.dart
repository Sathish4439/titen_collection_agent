import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/collection_history/viewmodel/collection_history_viewmodel.dart';
import 'package:collection_agent/modules/collection_history/views/widgets/collection_hero_card.dart';
import 'package:collection_agent/modules/collection_history/views/widgets/collection_search_bar.dart';
import 'package:collection_agent/modules/collection_history/views/widgets/payment_channel_chips.dart';
import 'package:collection_agent/modules/collection_history/views/widgets/transaction_card.dart';
import 'package:collection_agent/shared/models/transaction_model.dart';
import 'package:collection_agent/shared/widgets/mobile_frame_wrapper.dart';

/// Collection History Screen
/// STRICT RULES: Public StatelessWidget, NO setState(), observed with Selector
class CollectionHistoryScreen extends StatelessWidget {
  const CollectionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: MobileFrameWrapper(
          child: Column(
            children: [
              // Top App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      AppStrings.collectionHistoryTitle,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Body Content
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.success,
                  backgroundColor: Colors.white,
                  onRefresh: () => context.read<CollectionHistoryViewModel>().fetchHistory(isRefresh: true),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Hero Highlight Card
                      const CollectionHeroCard(),
                      SizedBox(height: 16.h),

                      // 2. Search & Calendar Row
                      const CollectionSearchBar(),
                      SizedBox(height: 20.h),

                      // 3. Payment Channels Horizontal Filter Chips
                      const PaymentChannelChips(),
                      SizedBox(height: 20.h),

                      // 4. Grouped Transactions List
                      Selector<CollectionHistoryViewModel, Map<String, List<TransactionModel>>>(
                        selector: (_, vm) => vm.groupedTransactions,
                        builder: (context, grouped, _) {
                          if (grouped.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 48.sp,
                                      color: AppColors.textMuted,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      AppStrings.noTransactionsFound,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: grouped.entries.map((entry) {
                              final groupName = entry.key;
                              final items = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date Group Header
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
                                    child: Text(
                                      groupName,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  // List of transaction cards
                                  ...items.map((tx) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      child: TransactionCard(transaction: tx),
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
