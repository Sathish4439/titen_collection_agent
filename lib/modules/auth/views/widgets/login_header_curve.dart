import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';

/// Top Curved Header matching Screen 1
class LoginHeaderCurve extends StatelessWidget {
  const LoginHeaderCurve({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ClipPath(
      clipper: const _BottomCurvedClipper(),
      child: Container(
        height: screenHeight * 0.48,
        width: double.infinity,
        color: AppColors.primary,
        padding: const EdgeInsets.only(top: 48, right: 24),
        alignment: Alignment.topRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NESTPILOT',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.appSubtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCurvedClipper extends CustomClipper<Path> {
  const _BottomCurvedClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 70);

    // Deep smooth parabolic curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.55,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
