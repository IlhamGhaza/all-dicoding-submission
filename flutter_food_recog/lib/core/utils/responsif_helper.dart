// lib/core/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  // Contoh penggunaan untuk padding responsif
  static EdgeInsets getSymmetricPadding(
    BuildContext context, {
    double horizontalFactor = 0.05,
    double verticalFactor = 0.02,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return EdgeInsets.symmetric(
      horizontal: screenWidth * horizontalFactor,
      vertical: screenHeight * verticalFactor,
    );
  }

  // Contoh penggunaan untuk ukuran font responsif
  static double getFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize * 0.9;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.3;
    }
  }
}
