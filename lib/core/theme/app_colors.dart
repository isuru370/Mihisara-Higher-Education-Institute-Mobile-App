import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // BRAND COLORS
  // =========================

  static const Color primary = Color(0xFF1D4ED8);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFFDBEAFE);

  static const Color secondary = Color(0xFF64748B);

  // =========================
  // STATUS COLORS
  // =========================

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFFE0F2FE);

  // =========================
  // BACKGROUND COLORS
  // =========================

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceSecondary = Color(0xFFF1F5F9);

  // =========================
  // DARK COLORS
  // =========================

  static const Color dark = Color(0xFF0F172A);
  static const Color darkLight = Color(0xFF1E293B);

  // =========================
  // TEXT COLORS
  // =========================

  static const Color textPrimary = dark;
  static const Color textSecondary = secondary;
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textWhite = Colors.white;

  // =========================
  // BORDER COLORS
  // =========================

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);

  // =========================
  // INPUT COLORS
  // =========================

  static const Color inputFill = Colors.white;
  static const Color inputBorder = Color(0xFFE2E8F0);

  // =========================
  // CARD COLORS
  // =========================

  static const Color cardBackground = Colors.white;

  // =========================
  // GRADIENTS
  // =========================

  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
  );

  // =========================
  // SHADOWS
  // =========================

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> largeShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 32,
      offset: const Offset(0, 14),
    ),
  ];

  // =========================
  // BORDER RADIUS
  // =========================

  static BorderRadius radiusSmall = BorderRadius.circular(12);
  static BorderRadius radiusMedium = BorderRadius.circular(18);
  static BorderRadius radiusLarge = BorderRadius.circular(26);
  static BorderRadius radiusXLarge = BorderRadius.circular(32);

  // =========================
  // SPACING
  // =========================

  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;

  // =========================
  // ICON COLORS
  // =========================

  static const Color iconPrimary = dark;
  static const Color iconSecondary = secondary;
  static const Color iconLight = Colors.white;
}
