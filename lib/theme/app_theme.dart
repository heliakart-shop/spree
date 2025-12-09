import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from design requirements
  static const Color yellow = Color(0xFFFFD93B);
  static const Color golden = Color(0xFFE6B325);
  static const Color orange = Color(0xFFFF8C42);
  static const Color redOrange = Color(0xFFD94E2B);
  static const Color lightBeige = Color(0xFFF5E6C4);
  static const Color brown = Color(0xFF8B4513);
  static const Color darkBlue = Color(0xFF1A1C37);
  
  // Semantic colors
  static const Color primary = yellow;
  static const Color secondary = golden;
  static const Color background = darkBlue;
  static const Color surface = darkBlue;
  static const Color onPrimary = darkBlue;
  static const Color onSurface = lightBeige;
  
  // Glassmorphism colors
  static Color glassBackground(Color baseColor, [double opacity = 0.2]) =>
      baseColor.withOpacity(opacity);
  
  static Color glassBorder(Color baseColor, [double opacity = 0.3]) =>
      baseColor.withOpacity(opacity);
  
  static Color glassShadow(Color baseColor, [double opacity = 0.1]) =>
      baseColor.withOpacity(opacity);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.yellow,
      AppColors.golden,
    ],
  );
  
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [
      AppColors.brown,
      AppColors.darkBlue,
    ],
  );
  
  static LinearGradient glassGradient(Color baseColor) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      baseColor.withOpacity(0.2),
      baseColor.withOpacity(0.05),
    ],
  );
}

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    color: AppColors.lightBeige,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    color: AppColors.lightBeige,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.lightBeige,
    fontSize: 16,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.lightBeige,
    fontSize: 14,
  );
  
  static TextStyle captionLight = TextStyle(
    color: AppColors.lightBeige.withOpacity(0.7),
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
}

class AppDecorations {
  static BoxDecoration glassContainer({
    required Color color,
    double borderRadius = 20,
    double borderWidth = 1,
    double shadowBlurRadius = 15,
    Offset shadowOffset = const Offset(0, 5),
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: AppGradients.glassGradient(color),
      border: Border.all(
        color: AppColors.glassBorder(color),
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.glassShadow(color),
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }
  
  static BoxDecoration iconContainer({
    required Color color,
    double borderRadius = 15,
    double size = 50,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: AppGradients.glassGradient(color),
      border: Border.all(
        color: AppColors.glassBorder(color),
        width: 1,
      ),
    );
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onPrimary,
      onSurface: AppColors.onSurface,
      onBackground: AppColors.onSurface,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 3000);
  
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve elastic = Curves.elasticOut;
  
  // Custom page transition
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = normal,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}