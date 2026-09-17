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

  String _formatDate(String rawDate) {
    final trimmed = rawDate.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
      return 'Not Provided';
    }
    try {
      final parsed = DateTime.tryParse(trimmed);
      if (parsed != null) {
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        final day = parsed.day.toString().padLeft(2, '0');
        final month = months[parsed.month - 1];
        final year = parsed.year.toString();
        return '$day $month $year';
      }
    } catch (_) {}
    return trimmed;
  }

  String _formatGender(String rawGender) {
    final g = rawGender.trim();
    if (g.isEmpty || g.toLowerCase() == 'null') return 'Not Provided';
    return g[0].toUpperCase() + g.substring(1).toLowerCase();
  }

  Widget _buildTextValue(String? val) {
    final s = val?.trim() ?? '';
    final isEmpty = s.isEmpty || s.toLowerCase() == 'null' || s.toLowerCase() == 'not provided';
    return Text(
      isEmpty ? 'Not Provided' : s,
      style: AppTextStyles.bodyMedium.copyWith(
        color: isEmpty ? AppColors.textMuted : AppColors.textPrimary,
        fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        tenant.initials,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final url = tenant.profileImageUrl?.trim();
    if (url != null && url.isNotEmpty && url.toLowerCase() != 'null') {
      return ClipOval(
        child: Image.network(
          url,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(),
        ),
      );
    }
    return _buildInitialsAvatar();
  }

  Widget _buildIdProofsList(List<String> proofs) {
    if (proofs.isEmpty) {
      return Text(
        'No ID proofs uploaded',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: proofs.asMap().entries.map((entry) {
        final index = entry.key;
        final url = entry.value;
        final isPdf = url.toLowerCase().contains('.pdf');
        final isImage = url.toLowerCase().contains('.png') ||
            url.toLowerCase().contains('.jpg') ||
            url.toLowerCase().contains('.jpeg');

        final iconData = isPdf
            ? Icons.picture_as_pdf_outlined
            : (isImage ? Icons.image_outlined : Icons.insert_drive_file_outlined);
        final iconColor = isPdf
            ? const Color(0xFFE53935)
            : (isImage ? const Color(0xFF1E88E5) : AppColors.primary);

        String title;
        try {
          final uri = Uri.parse(url);
          final filename = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
          if (filename.isNotEmpty) {
            final ext = filename.contains('.') ? '.${filename.split('.').last}' : '';
            title = 'Document ${index + 1} ($ext)';
          } else {
            title = 'Document ${index + 1}';
          }
        } catch (_) {
          title = 'Document ${index + 1}';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Row(
            children: [
              Icon(iconData, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
                  _buildAvatar(),
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
                          valueWidget: _buildTextValue(tenant.name),
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
                          valueWidget: _buildTextValue(tenant.email),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.phone_outlined,
                          label: AppStrings.labelPhone,
                          valueWidget: _buildTextValue(tenant.phone),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.calendar_today_outlined,
                          label: AppStrings.labelDob,
                          valueWidget: _buildTextValue(_formatDate(tenant.dob)),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.calendar_today_outlined,
                          label: AppStrings.labelJoiningDate,
                          valueWidget: _buildTextValue(_formatDate(tenant.joiningDate)),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.people_outline,
                          label: AppStrings.labelGender,
                          valueWidget: _buildTextValue(_formatGender(tenant.gender)),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.badge_outlined,
                          label: AppStrings.labelIdProofs,
                          valueWidget: _buildIdProofsList(tenant.idProofs),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.contact_phone_outlined,
                          label: AppStrings.labelEmergencyContact1,
                          valueWidget: _buildTextValue(tenant.emergencyContact1),
                        ),
                        _buildDivider(),
                        _buildTableRow(
                          icon: Icons.contact_phone_outlined,
                          label: AppStrings.labelEmergencyContact2,
                          valueWidget: _buildTextValue(tenant.emergencyContact2),
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
