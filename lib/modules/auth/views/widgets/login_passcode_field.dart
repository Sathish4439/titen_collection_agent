import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/auth/viewmodel/auth_viewmodel.dart';

/// 4-Digit Passcode / PIN Input Field
class LoginPasscodeField extends StatefulWidget {
  const LoginPasscodeField({super.key});

  @override
  State<LoginPasscodeField> createState() => _LoginPasscodeFieldState();
}

class _LoginPasscodeFieldState extends State<LoginPasscodeField> {
  bool _obscurePasscode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.passcodeLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePasscode = !_obscurePasscode;
                });
              },
              child: Text(
                _obscurePasscode ? 'Show PIN' : 'Hide PIN',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: context.read<AuthViewModel>().passcode,
          keyboardType: TextInputType.number,
          obscureText: _obscurePasscode,
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 8.0,
          ),
          decoration: InputDecoration(
            counterText: '',
            isDense: true,
            hintText: '••••',
            hintStyle: const TextStyle(letterSpacing: 6.0, color: Colors.grey),
            contentPadding: const EdgeInsets.only(bottom: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            suffixIcon: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          onChanged: (val) {
            context.read<AuthViewModel>().updatePasscode(val);
          },
        ),
      ],
    );
  }
}
