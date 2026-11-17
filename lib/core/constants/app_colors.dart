import 'package:flutter/material.dart';

/// App color palette following the design specifications:
/// - Deep midnight navy (Primary)
/// - Fresh teal/emerald (Accent)
/// - Warm ivory / soft neutral (Background)
/// - Restrained warm amber (Highlight)
class AppColors {
  AppColors._();

  // Primary Brand Colors (Midnight Navy)
  static const Color midnightNavy = Color(0xFF0F172A); // Slate 900
  static const Color navySecondary = Color(0xFF1E293B); // Slate 800
  static const Color navyCard = Color(0xFF334155); // Slate 700

  // Accent Colors (Fresh Teal / Emerald)
  static const Color tealAccent = Color(0xFF0D9488); // Teal 600
  static const Color tealLight = Color(0xFF14B8A6); // Teal 500
  static const Color tealDark = Color(0xFF0F766E); // Teal 700
  static const Color tealSubtle = Color(0xFFCCFBF1); // Teal 100

  // Background Colors (Warm Ivory & Neutral Tones)
  static const Color ivoryBackground = Color(0xFFFBFBFA);
  static const Color warmLight = Color(0xFFF8FAFC);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // Warm Restrained Highlight (Amber/Gold)
  static const Color warmAmber = Color(0xFFD97706); // Amber 600
  static const Color warmAmberLight = Color(0xFFFEF3C7); // Amber 100
  static const Color warmCoral = Color(0xFFEA580C); // Orange 600

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFF8FAFC);

  // Border & Divider Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Status Colors
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusSuccessBg = Color(0xFFD1FAE5);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusPendingBg = Color(0xFFFEF3C7);
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusErrorBg = Color(0xFFFEE2E2);
  static const Color statusCancelled = Color(0xFF64748B);
  static const Color statusCancelledBg = Color(0xFFF1F5F9);
}

