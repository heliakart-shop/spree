class AppConstants {
  // App Information
  static const String appName = 'Spree Party';
  static const String appTagline = 'AI-Powered Party Games';
  static const String appDescription = 'AI Party Games Generator';
  
  // Version
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  
  // Shared Preferences Keys
  static const String isFirstLaunchKey = 'isFirstLaunch';
  static const String userPreferencesKey = 'userPreferences';
  static const String gameHistoryKey = 'gameHistory';
  static const String settingsKey = 'appSettings';
  
  // Animation Durations (in milliseconds)
  static const int splashDuration = 3000;
  static const int quickAnimation = 200;
  static const int normalAnimation = 300;
  static const int slowAnimation = 500;
  static const int welcomePageDelay = 200;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double smallBorderRadius = 10.0;
  static const double defaultBorderRadius = 20.0;
  static const double largeBorderRadius = 30.0;
  
  static const double iconSizeSmall = 20.0;
  static const double iconSizeDefault = 24.0;
  static const double iconSizeLarge = 60.0;
  
  static const double buttonHeight = 50.0;
  static const double cardElevation = 4.0;
  
  // Grid Layout
  static const int menuGridColumns = 2;
  static const double menuGridSpacing = 16.0;
  static const double menuGridAspectRatio = 0.85;
  
  // Welcome Screen
  static const int welcomePageCount = 3;
  
  // API Constants (for future use)
  static const String apiBaseUrl = 'https://api.openai.com/v1/';
  static const String claudeApiUrl = 'https://api.anthropic.com/v1/';
  
  // Feature Flags (for future use)
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
  static const bool enableBetaFeatures = false;
  
  // Game Categories (for future use)
  static const List<String> gameCategories = [
    'Ice Breakers',
    'Team Building',
    'Creative Games',
    'Physical Activities',
    'Mind Games',
    'Party Classics',
  ];
  
  // Difficulty Levels (for future use)
  static const List<String> difficultyLevels = [
    'Easy',
    'Medium',
    'Hard',
    'Expert',
  ];
  
  // Party Sizes (for future use)
  static const List<String> partySizes = [
    'Small (2-5 people)',
    'Medium (6-10 people)',
    'Large (11-20 people)',
    'Extra Large (20+ people)',
  ];
}