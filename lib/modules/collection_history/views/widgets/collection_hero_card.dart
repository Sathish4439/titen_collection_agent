import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/collection_history/viewmodel/collection_history_viewmodel.dart';

/// Top Hero Highlight Card displaying Property Name and Big Total Amount
class CollectionHeroCard extends StatelessWidget {
  const CollectionHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.heroCardBg,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.titanPg,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Selector<CollectionHistoryViewModel, String>(
            selector: (_, vm) => vm.metrics.formattedTotal,
            builder: (context, formattedTotal, _) {
              return Text(
                formattedTotal,
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
