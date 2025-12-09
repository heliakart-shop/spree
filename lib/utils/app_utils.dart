import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AppUtils {
  // Haptic Feedback
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }
  
  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }
  
  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }
  
  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  // Navigation Helpers
  static void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      AppAnimations.fadeTransition(page: page),
    );
  }
  
  static void navigateAndReplace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      AppAnimations.fadeTransition(page: page),
    );
  }
  
  static void navigateAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      AppAnimations.fadeTransition(page: page),
      (route) => false,
    );
  }

  // Screen Size Helpers
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 375;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) > 414;
  }

  // Device Info
  static bool isIPhone(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }
  
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Text Helpers
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  static String capitalizeWords(String text) {
    return text.split(' ')
        .map((word) => capitalizeFirstLetter(word))
        .join(' ');
  }

  // Color Helpers
  static Color getRandomColor() {
    const colors = [
      AppColors.yellow,
      AppColors.golden,
      AppColors.orange,
      AppColors.redOrange,
    ];
    return colors[(DateTime.now().millisecondsSinceEpoch % colors.length)];
  }
  
  static Color lightenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
  
  static Color darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return hslDark.toColor();
  }

  // Animation Helpers
  static AnimationController createAnimationController({
    required TickerProvider vsync,
    required Duration duration,
  }) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }
  
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: AppAnimations.easeIn,
    ));
  }
  
  static Animation<Offset> createSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: AppAnimations.easeOut,
    ));
  }

  // Validation Helpers
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
  
  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }
  
  static bool isValidPartySize(int size) {
    return size >= 2 && size <= 100;
  }

  // Formatting Helpers
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  
  static String formatGameDuration(int minutes) {
    if (minutes < 60) {
      return "$minutes min";
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return "${hours}h";
      }
      return "${hours}h ${remainingMinutes}min";
    }
  }
  
  static String formatPlayerCount(int count) {
    if (count == 1) return "1 player";
    return "$count players";
  }

  // Date Helpers
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    if (difference < 7) return "$difference days ago";
    if (difference < 30) return "${difference ~/ 7} weeks ago";
    if (difference < 365) return "${difference ~/ 30} months ago";
    return "${difference ~/ 365} years ago";
  }
  
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  // Debug Helpers
  static void debugPrint(String message, [String? tag]) {
    if (tag != null) {
      debugPrint("[$tag] $message");
    } else {
      debugPrint(message);
    }
  }
  
  static void logError(String error, [StackTrace? stackTrace]) {
    debugPrint("ERROR: $error");
    if (stackTrace != null) {
      debugPrint("Stack trace: $stackTrace");
    }
  }

  // UI Helper Methods
  static void showSnackBar(BuildContext context, String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? AppColors.lightBeige),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? AppColors.darkBlue.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  static Future<bool?> showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.lightBeige),
        ),
        content: Text(
          message,
          style: TextStyle(color: AppColors.lightBeige.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: TextStyle(color: AppColors.lightBeige.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Performance Helpers
  static void precacheImages(BuildContext context, List<String> imagePaths) {
    for (String path in imagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }
  
  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Math Helpers
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  static int randomInt(int min, int max) {
    return min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));
  }
  
  static double randomDouble(double min, double max) {
    final random = (DateTime.now().millisecondsSinceEpoch % 1000) / 1000.0;
    return min + (max - min) * random;
  }

  // Storage Helpers (for future use with SharedPreferences)
  static const String _keyPrefix = 'spree_party_';
  
  static String getStorageKey(String key) {
    return _keyPrefix + key;
  }
}