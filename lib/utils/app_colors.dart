import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0F1117);
  static const surface = Color(0xFF181C27);
  static const card = Color(0xFF1E2335);
  static const teal = Color(0xFF1ECFB3);
  static const tealDark = Color(0xFF17A896);
  static const tealBg = Color(0xFF0D3D38);
  static const orange = Color(0xFFE07B3F);
  static const purple = Color(0xFF6B7ADE);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0B8CC);
  static const textMuted = Color(0xFF6B7485);
  static const border = Color(0xFF262D3F);
  static const activeGreen = Color(0xFF22C55E);
  static const idleOrange = Color(0xFFF59E0B);
  static const pendingGray = Color(0xFF6B7485);
 
}

class AppTextStyles {
  static const heading1 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const heading2 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const heading3 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static const caption = TextStyle(
    color: AppColors.textMuted,
    fontSize: 12,
  );

  static const label = TextStyle(
    color: AppColors.teal,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}