/// lib/core/app_colors.dart
///
/// Defines the color palette for the application, based on the provided screenshots.
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF6B4EEF);
  static const Color accentBlue = Color(0xFF5E60CE); // A slightly different blue from the gradient
  static const Color backgroundLight = Color(0xFFF8F8F8);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color greyText = Color(0xFF888888);
  static const Color lightGreyBackground = Color(0xFFEEEEEE);
  static const Color redError = Color(0xFFD32F2F);

  // Task priority colors
  static const Color priorityLow = Color(0xFF4CAF50); // Green
  static const Color priorityMedium = Color(0xFFFFC107); // Amber
  static const Color priorityHigh = Color(0xFFF44336); // Red

  // Tag colors (example, adjust as needed)
  static const Color tagPersonal = Color(0xFFFF9800); // Orange
  static const Color tagWork = Color(0xFF2196F3);     // Blue
  static const Color tagStudy = Color(0xFF9C27B0);    // Purple
  static const Color tagApp = Color(0xFFE91E63);      // Pink

  // Gradients for UI elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

