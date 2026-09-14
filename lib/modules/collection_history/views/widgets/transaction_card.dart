import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/shared/models/transaction_model.dart';

/// Single Transaction item card matching design mockup
class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Initials Avatar Circle
          Container(
            width: 44.h,
            height: 44.h,
            decoration: const BoxDecoration(
              color: AppColors.avatarBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              transaction.tenantInitials,
              style: AppTextStyles.titleSmall.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.avatarText,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          // Tenant Name & Timestamp/Method Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.tenantName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${transaction.createdTime} • ${transaction.displayPaymentMethod}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount in Bold
          Text(
            transaction.formattedAmount,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
