import 'package:flutter/material.dart';

/// SAHOOL Color System - Professional Agricultural Theme
class AppColors {
  AppColors._();

  // PRIMARY COLORS
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySurface = Color(0xFFE8F5E9);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
  );

  // SECONDARY COLORS
  static const Color secondary = Color(0xFFFFB300);
  static const Color secondaryLight = Color(0xFFFFCA28);
  static const Color secondaryDark = Color(0xFFFF8F00);

  // SEMANTIC COLORS
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFFFA726);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF42A5F5);
  static const Color infoLight = Color(0xFFBBDEFB);

  // NEUTRAL COLORS
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);

  // TEXT COLORS
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;

  // BACKGROUND COLORS
  static const Color backgroundLight = Color(0xFFF8FAF8);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF2D2D2D);

  // SPECIAL
  static const Color divider = Color(0xFFE8E8E8);
  static const Color shadow = Color(0x1A000000);

  // NDVI Colors
  static Color getNdviColor(double ndvi) {
    if (ndvi >= 0.8) return const Color(0xFF1B5E20);
    if (ndvi >= 0.6) return const Color(0xFF4CAF50);
    if (ndvi >= 0.4) return const Color(0xFFFFEB3B);
    if (ndvi >= 0.2) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
  
  static String getNdviLabel(double ndvi) {
    if (ndvi >= 0.8) return 'ممتاز';
    if (ndvi >= 0.6) return 'جيد';
    if (ndvi >= 0.4) return 'متوسط';
    if (ndvi >= 0.2) return 'ضعيف';
    return 'حرج';
  }
  
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': case 'done': case 'active': return success;
      case 'in_progress': case 'processing': return info;
      case 'pending': case 'waiting': return warning;
      case 'cancelled': case 'failed': case 'error': return error;
      default: return neutral500;
    }
  }
  
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent': return const Color(0xFFD32F2F);
      case 'high': return error;
      case 'medium': return warning;
      case 'low': return success;
      default: return neutral500;
    }
  }
}
