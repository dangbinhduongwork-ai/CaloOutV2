import 'package:flutter/material.dart';

/// App color definitions adhering to Material 3 palette guidelines.
/// Seed color is Emerald Green for healthy vitality, paired with energetic Warm Orange for calories burned.
class AppColors {
  AppColors._();

  // Primary Brand - Healthy Emerald Green
  static const Color primary = Color(0xFF059669);
  static const Color primaryLight = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF047857);

  // Secondary Brand - Calorie Burn / Energy Orange
  static const Color calorieOrange = Color(0xFFFF6B00);
  static const Color calorieOrangeLight = Color(0xFFFF8533);
  static const Color calorieOrangeDark = Color(0xFFCC5500);

  // Accent / Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightOutline = Color(0xFFCBD5E1);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0B131E);
  static const Color darkSurface = Color(0xFF152232);
  static const Color darkSurfaceVariant = Color(0xFF1E2F44);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF334155);

  // Gradients
  static const LinearGradient calorieBurnGradient = LinearGradient(
    colors: [Color(0xFFFF8533), Color(0xFFFF5200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient healthProgressGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFF064E3B), Color(0xFF047857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
