import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/room_management/viewmodel/room_management_viewmodel.dart';

/// Screen 3: Payment Collection Modal Bottom Sheet
/// STRICT RULES: Public StatelessWidget, NO setState(), observed with Selector
class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return ChangeNotifierProvider.value(
          value: context.read<RoomManagementViewModel>(),
          child: const PaymentBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<RoomManagementViewModel>();
    final activeBed = vm.activeBedForPayment;
    final roomNumber = vm.activeRoomNumberForPayment ?? '';
    final tenantName = activeBed?.tenant?.name ?? 'Tenant';
    final amountDue = activeBed?.amountDue ?? 0.0;
    final formattedDue = '${AppStrings.currencySymbol}${amountDue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFA3B899),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header Row: Title and Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$roomNumber - $tenantName',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
          const SizedBox(height: 16),

          // Amount Due Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.amountDue,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
              Text(
                formattedDue,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Field 1: Full / Partial Payment Dropdown
          Text(
            AppStrings.fullPartialPayment,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Selector<RoomManagementViewModel, String>(
            selector: (_, vm) => vm.paymentType,
            builder: (context, paymentType, _) {
              return Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: paymentType == AppStrings.selectPayment ? null : paymentType,
                    hint: Text(
                      AppStrings.selectPayment,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    items: [
                      AppStrings.fullPayment,
                      AppStrings.partialPayment,
                    ].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<RoomManagementViewModel>().updatePaymentType(val);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Field 2: Payment Option Dropdown
          Text(
            AppStrings.paymentOption,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Selector<RoomManagementViewModel, String>(
            selector: (_, vm) => vm.selectedPaymentOption,
            builder: (context, selectedOption, _) {
              return Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedOption == AppStrings.selectPaymentOption ? null : selectedOption,
                    hint: Text(
                      AppStrings.selectPaymentOption,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    items: [
                      AppStrings.paymentOptionCash,
                      AppStrings.paymentOptionUPI,
                      AppStrings.paymentOptionCard,
                      AppStrings.paymentOptionNetBanking,
                    ].map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        context.read<RoomManagementViewModel>().updatePaymentOption(val);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Field 3: Amount * Input Field
          RichText(
            text: TextSpan(
              text: 'Amount ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Selector<RoomManagementViewModel, String>(
            selector: (_, vm) => vm.paymentType,
            builder: (context, paymentType, _) {
              final vm = context.read<RoomManagementViewModel>();

              return SizedBox(
                height: 44,
                child: TextFormField(
                  controller: vm.paymentAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
          const SizedBox(height: 16),

          // Action Buttons: Cancel and Pay
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF1E293B), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppStrings.cancel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Selector<RoomManagementViewModel, bool>(
                  selector: (_, vm) => vm.isSubmittingPayment,
                  builder: (context, isSubmitting, _) {
                    return SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                final success = context.read<RoomManagementViewModel>().submitPayment();
                                if (success) {
                                  Navigator.of(context).pop();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A0A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.submitPay,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
