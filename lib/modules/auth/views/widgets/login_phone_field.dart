import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/auth/viewmodel/auth_viewmodel.dart';

/// Phone Input Field with Label and Underline border matching Screen 1
class LoginPhoneField extends StatelessWidget {
  const LoginPhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.phoneLabel,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: context.read<AuthViewModel>().phoneNumber,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s+]')),
          ],
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            prefixText: '+91 ',
            prefixStyle: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          onChanged: (val) {
            context.read<AuthViewModel>().updatePhoneNumber(val);
          },
        ),
        Selector<AuthViewModel, String?>(
          selector: (_, vm) => vm.errorMessage,
          builder: (_, error, _) {
            if (error == null || error.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                error,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
