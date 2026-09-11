import 'package:flutter/material.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/shared/models/tenant_model.dart';

/// Screen 4: Customer Details & KYC Modal Bottom Sheet
/// STRICT RULE: Public StatelessWidget, matches Screen 4 pixel-perfect
class CustomerDetailsBottomSheet extends StatelessWidget {
  final TenantModel tenant;

  const CustomerDetailsBottomSheet({
    super.key,
    required this.tenant,
  });

  static void show(BuildContext context, TenantModel tenant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerDetailsBottomSheet(tenant: tenant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: AppStrings.customerDetailsPrefix,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: tenant.name,
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 22, color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Center Profile Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Key-Value Table Container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildTableRow(
                          icon: Icons.person_outline,
                          label: AppStrings.labelName,
                          valueWidget: Text(tenant.name, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          label: AppStrings.labelCustomerId,
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.purpleBadgeLight,
                              border: Border.all(color: AppColors.purpleBadge.withValues(alpha: 0.5)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tenant.customerId,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.purpleBadge,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.mail_outline,
                          label: AppStrings.labelEmail,
                          valueWidget: Text(tenant.email, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.phone_outlined,
                          label: AppStrings.labelPhone,
                          valueWidget: Text(tenant.phone, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.calendar_today_outlined,
                          label: AppStrings.labelDob,
                          valueWidget: Text(tenant.dob, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.calendar_today_outlined,
                          label: AppStrings.labelJoiningDate,
                          valueWidget: Text(tenant.joiningDate, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          label: AppStrings.labelGender,
                          valueWidget: Text(tenant.gender, style: AppTextStyles.bodyMedium),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.edit_document,
                          label: AppStrings.labelIdProofs,
                          valueWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tenant.idProofs.map((proof) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    const Icon(Icons.insert_drive_file_outlined,
                                        size: 16, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        proof,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          label: AppStrings.labelEmergencyContact1,
                          valueWidget: Text(
                            tenant.emergencyContact1,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          label: AppStrings.labelEmergencyContact2,
                          valueWidget: Text(
                            tenant.emergencyContact2,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.home_outlined,
                          label: AppStrings.labelRoom,
                          valueWidget: Text(
                            '${tenant.roomNumber} (${tenant.blockName})',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          label: AppStrings.labelStatus,
                          valueWidget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              border: Border.all(color: AppColors.success),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tenant.status,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    IconData? icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: valueWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: AppColors.border, height: 1, thickness: 1);
  }
}
