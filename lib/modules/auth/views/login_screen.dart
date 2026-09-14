import 'package:flutter/material.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';
import 'package:collection_agent/modules/auth/views/widgets/login_button.dart';
import 'package:collection_agent/modules/auth/views/widgets/login_header_curve.dart';
import 'package:collection_agent/modules/auth/views/widgets/login_passcode_field.dart';
import 'package:collection_agent/modules/auth/views/widgets/login_phone_field.dart';
import 'package:collection_agent/shared/widgets/mobile_frame_wrapper.dart';

/// Screen 1: Agent Authentication Screen
/// STRICT RULE: Public StatelessWidget, NO setState(), observed with Selector
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MobileFrameWrapper(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const LoginHeaderCurve(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.welcomeBack,
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.pleaseSignIn,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const LoginPhoneField(),
                    const SizedBox(height: 24),
                    const LoginPasscodeField(),
                    const SizedBox(height: 36),
                    const LoginButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
