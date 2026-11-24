import 'package:flutter/material.dart';

/// Trailblazer AI design tokens — teal / forest green theme from reference UI.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF006D77);
  static const Color primaryDark = Color(0xFF004D40);
  static const Color primaryLight = Color(0xFF2A9D8F);
  static const Color accent = Color(0xFF4DB6AC);
  static const Color softTeal = Color(0xFFE0F2F1);
  static const Color softTealAlt = Color(0xFFF0F7F6);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF5F7F8);
  static const Color surfaceBlue = Color(0xFFF0F4F8);

  static const Color textPrimary = Color(0xFF1A2332);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color mustVisit = Color(0xFF7C3AED);
  static const Color mustVisitBg = Color(0xFFF3E8FF);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFEF4444);
  static const Color border = Color(0xFFE5E7EB);
  static const Color chipBg = Color(0xFFF3F4F6);
  static const Color dailyBudgetBg = Color(0xFFFFF8E7);
  static const Color navInactive = Color(0xFF9CA3AF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF006D77), Color(0xFF2A9D8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient budgetCardGradient = LinearGradient(
    colors: [Color(0xFF006D77), Color(0xFF0D9488)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
