import 'package:flutter/material.dart';

/// Centralized Color Constants
/// Mapped to exact design tokens from the 4 screens
class AppColors {
  AppColors._();

  // Primary Branding
  static const Color primary = Color(0xFF0080FF);
  static const Color primaryLight = Color(0xFFEBF5FF);
  static const Color primaryDark = Color(0xFF0066CC);

  // Status & Badges
  static const Color success = Color(0xFF0D7A53);
  static const Color successLight = Color(0xFFE8F8F0);
  static const Color bedGreen = Color(0xFF22C55E);
  static const Color bedGreenLight = Color(0xFFEBFDF2);

  static const Color purpleBadge = Color(0xFF7C3AED);
  static const Color purpleBadgeLight = Color(0xFFF3E8FF);

  // Neutrals & Surfaces
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color darkButton = Color(0xFF1E293B);

  // Typography & Borders
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Overlay / Modal Scrim
  static const Color modalScrim = Color(0x66000000);
  static const Color modalGrabHandle = Color(0xFFCBD5E1);

  // Avatar Initials
  static const Color avatarBg = Color(0xFFF1F5F9);
  static const Color avatarText = Color(0xFF475569);

  // Collection History Screen
  static const Color heroCardBg = Color(0xFFEFF4FE);
  static const Color searchFieldBg = Color(0xFFF1F5F9);
  static const Color chipInactiveBorder = Color(0xFFE2E8F0);
  static const Color chipInactiveBadgeBg = Color(0xFFF1F5F9);
  static const Color chipActiveBg = Color(0xFF0D7A53);
}
