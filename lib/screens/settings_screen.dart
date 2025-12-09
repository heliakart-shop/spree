import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _sectionsController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Settings state
  bool notificationsEnabled = true;
  bool soundEffectsEnabled = true;
  bool hapticFeedbackEnabled = true;
  bool autoSaveGames = true;
  bool darkModeEnabled = true;
  bool analyticsEnabled = false;
  String selectedLanguage = 'English';
  String selectedTheme = 'Dark';
  double aiCreativityLevel = 0.7;
  double gameComplexity = 0.5;
  int defaultParticipants = 5;
  int defaultDuration = 15;

  final List<String> languages = [
    'English', 
    'Українська', 
    'Español', 
    'Français', 
    'Deutsch',
    'Italiano',
    'Português',
    '中文',
    '日本語',
  ];
  
  final List<String> themes = ['Dark', 'Light', 'Auto'];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sectionsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sectionsController,
      curve: AppAnimations.easeOut,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _sectionsController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _sectionsController.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    if (hapticFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Settings content
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('General', Icons.tune),
                          _buildGeneralSettings(),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('AI & Generation', Icons.psychology),
                          _buildAISettings(),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('Default Game Settings', Icons.games),
                          _buildDefaultGameSettings(),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('Notifications & Feedback', Icons.notifications),
                          _buildNotificationSettings(),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('Privacy & Data', Icons.security),
                          _buildPrivacySettings(),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('About & Support', Icons.info),
                          _buildAboutSettings(),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.brown.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _triggerHaptic();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.lightBeige,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: AppDecorations.glassContainer(
              color: AppColors.brown,
              borderRadius: 12,
            ),
            child: Icon(
              Icons.settings,
              color: AppColors.brown,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTextStyles.headlineMedium,
              ),
              Text(
                'Customize your experience',
                style: TextStyle(
                  color: AppColors.lightBeige.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: AppDecorations.glassContainer(
              color: AppColors.golden,
              borderRadius: 15,
            ),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                color: AppColors.golden,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.golden,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 20,
              color: AppColors.golden,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      children: [
        _buildDropdownSetting(
          title: 'Language',
          subtitle: 'Choose your preferred language',
          value: selectedLanguage,
          items: languages,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              selectedLanguage = value!;
            });
            if (value != 'English') {
              _showComingSoon('Language support for $value');
            }
          },
          icon: Icons.language,
        ),
        const SizedBox(height: 16),
        _buildDropdownSetting(
          title: 'Theme',
          subtitle: 'Select app appearance',
          value: selectedTheme,
          items: themes,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              selectedTheme = value!;
            });
            if (value != 'Dark') {
              _showComingSoon('$value theme');
            }
          },
          icon: Icons.palette,
        ),
        const SizedBox(height: 16),
        _buildSwitchSetting(
          title: 'Auto-save Games',
          subtitle: 'Automatically save generated games to your collection',
          value: autoSaveGames,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              autoSaveGames = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value ? 'Auto-save enabled' : 'Auto-save disabled',
                ),
                backgroundColor: AppColors.golden,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          icon: Icons.save,
        ),
      ],
    );
  }

  Widget _buildAISettings() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.glassContainer(
            color: AppColors.yellow,
            borderRadius: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, color: AppColors.yellow, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Creativity Level',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'How creative and unique should generated games be?',
                          style: TextStyle(
                            color: AppColors.lightBeige.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(aiCreativityLevel * 100).round()}%',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.yellow,
                  inactiveTrackColor: AppColors.yellow.withOpacity(0.3),
                  thumbColor: AppColors.yellow,
                  overlayColor: AppColors.yellow.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: aiCreativityLevel,
                  onChanged: (value) {
                    if (hapticFeedbackEnabled) {
                      HapticFeedback.selectionClick();
                    }
                    setState(() {
                      aiCreativityLevel = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Conservative',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Balanced',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Wild & Creative',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.glassContainer(
            color: AppColors.orange,
            borderRadius: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.compass_calibration, color: AppColors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Complexity',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Default complexity level for generated games',
                          style: TextStyle(
                            color: AppColors.lightBeige.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getComplexityLabel(gameComplexity),
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.orange,
                  inactiveTrackColor: AppColors.orange.withOpacity(0.3),
                  thumbColor: AppColors.orange,
                  overlayColor: AppColors.orange.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: gameComplexity,
                  divisions: 3,
                  onChanged: (value) {
                    if (hapticFeedbackEnabled) {
                      HapticFeedback.selectionClick();
                    }
                    setState(() {
                      gameComplexity = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Simple',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Medium',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Complex',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Expert',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getComplexityLabel(double value) {
    if (value <= 0.25) return 'Simple';
    if (value <= 0.5) return 'Medium';
    if (value <= 0.75) return 'Complex';
    return 'Expert';
  }

  Widget _buildDefaultGameSettings() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.glassContainer(
            color: AppColors.lightBeige,
            borderRadius: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.group, color: AppColors.lightBeige, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Participants',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Default number of players for new games',
                          style: TextStyle(
                            color: AppColors.lightBeige.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightBeige.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$defaultParticipants people',
                      style: TextStyle(
                        color: AppColors.lightBeige,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.lightBeige,
                  inactiveTrackColor: AppColors.lightBeige.withOpacity(0.3),
                  thumbColor: AppColors.lightBeige,
                  overlayColor: AppColors.lightBeige.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: defaultParticipants.toDouble(),
                  min: 2,
                  max: 20,
                  divisions: 18,
                  onChanged: (value) {
                    if (hapticFeedbackEnabled) {
                      HapticFeedback.selectionClick();
                    }
                    setState(() {
                      defaultParticipants = value.round();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.glassContainer(
            color: AppColors.redOrange,
            borderRadius: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.redOrange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Duration',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Default game duration in minutes',
                          style: TextStyle(
                            color: AppColors.lightBeige.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.redOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$defaultDuration min',
                      style: TextStyle(
                        color: AppColors.redOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.redOrange,
                  inactiveTrackColor: AppColors.redOrange.withOpacity(0.3),
                  thumbColor: AppColors.redOrange,
                  overlayColor: AppColors.redOrange.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: defaultDuration.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  onChanged: (value) {
                    if (hapticFeedbackEnabled) {
                      HapticFeedback.selectionClick();
                    }
                    setState(() {
                      defaultDuration = value.round();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        _buildSwitchSetting(
          title: 'Push Notifications',
          subtitle: 'Receive updates, tips, and reminders',
          value: notificationsEnabled,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              notificationsEnabled = value;
            });
            if (value) {
              _showComingSoon('Push notifications');
            }
          },
          icon: Icons.notifications,
        ),
        const SizedBox(height: 16),
        _buildSwitchSetting(
          title: 'Sound Effects',
          subtitle: 'Play sounds for interactions and feedback',
          value: soundEffectsEnabled,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              soundEffectsEnabled = value;
            });
            if (value) {
              // Play a sample sound effect
              SystemSound.play(SystemSoundType.click);
            }
          },
          icon: Icons.volume_up,
        ),
        const SizedBox(height: 16),
        _buildSwitchSetting(
          title: 'Haptic Feedback',
          subtitle: 'Feel vibrations for button presses and interactions',
          value: hapticFeedbackEnabled,
          onChanged: (value) {
            setState(() {
              hapticFeedbackEnabled = value;
            });
            if (value) {
              HapticFeedback.mediumImpact();
            }
          },
          icon: Icons.vibration,
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      children: [
        _buildSwitchSetting(
          title: 'Analytics & Crash Reports',
          subtitle: 'Help improve the app by sharing anonymous usage data',
          value: analyticsEnabled,
          onChanged: (value) {
            _triggerHaptic();
            setState(() {
              analyticsEnabled = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value 
                      ? 'Analytics enabled - Thank you for helping improve the app!' 
                      : 'Analytics disabled - Your privacy is respected',
                ),
                backgroundColor: AppColors.lightBeige,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          icon: Icons.analytics,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Clear Cache',
          subtitle: 'Free up storage space (${_getCacheSize()})',
          onTap: () {
            _triggerHaptic();
            _showClearCacheDialog();
          },
          icon: Icons.cleaning_services,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Export Data',
          subtitle: 'Export your saved games and settings',
          onTap: () {
            _triggerHaptic();
            _showComingSoon('Data export');
          },
          icon: Icons.download,
        ),
      ],
    );
  }

  String _getCacheSize() {
    // Mock cache size calculation
    const sizes = ['2.3 MB', '1.8 MB', '3.1 MB', '4.2 MB', '1.5 MB'];
    return sizes[DateTime.now().millisecond % sizes.length];
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        _buildSettingTile(
          title: 'App Version',
          subtitle: '1.0.0 (Build 1) - Latest',
          onTap: () {
            _triggerHaptic();
            _showVersionInfo();
          },
          icon: Icons.info,
          showArrow: false,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'What\'s New',
          subtitle: 'See the latest features and improvements',
          onTap: () {
            _triggerHaptic();
            _showWhatsNew();
          },
          icon: Icons.new_releases,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy and data handling',
          onTap: () {
            _triggerHaptic();
            _showComingSoon('Privacy Policy');
          },
          icon: Icons.privacy_tip,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service and user agreement',
          onTap: () {
            _triggerHaptic();
            _showComingSoon('Terms of Service');
          },
          icon: Icons.description,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Contact Support',
          subtitle: 'Get help or report issues',
          onTap: () {
            _triggerHaptic();
            _showSupportOptions();
          },
          icon: Icons.support_agent,
        ),
        const SizedBox(height: 16),
        _buildSettingTile(
          title: 'Rate Spree Party',
          subtitle: 'Love the app? Rate us on the App Store',
          onTap: () {
            _triggerHaptic();
            _showRatingPrompt();
          },
          icon: Icons.star,
        ),
      ],
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 15,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: AppColors.lightBeige, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.lightBeige.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.lightBeige,
                  activeTrackColor: AppColors.lightBeige.withOpacity(0.3),
                  inactiveThumbColor: AppColors.lightBeige.withOpacity(0.5),
                  inactiveTrackColor: AppColors.darkBlue.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lightBeige, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.lightBeige.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.darkBlue.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            dropdownColor: AppColors.darkBlue,
            style: TextStyle(color: AppColors.lightBeige),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required IconData icon,
    bool showArrow = true,
  }) {
    return Container(
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 15,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: AppColors.lightBeige, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.lightBeige.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.lightBeige.withOpacity(0.5),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder(AppColors.golden),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info,
              color: AppColors.golden,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'App Information',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Version', '1.0.0'),
            _buildInfoRow('Build', '1'),
            _buildInfoRow('Platform', 'iOS'),
            _buildInfoRow('Release Date', 'September 2025'),
            const SizedBox(height: 16),
            Text(
              'Spree Party - AI-Powered Party Games Generator',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.lightBeige.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.golden),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.lightBeige.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showWhatsNew() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder(AppColors.yellow),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.new_releases,
              color: AppColors.yellow,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'What\'s New in v1.0.0',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureItem('🎮', 'AI Game Generation', 'Create unlimited party games with Claude AI'),
              _buildFeatureItem('💾', 'Save & Organize', 'Save your favorite games and organize them by type'),
              _buildFeatureItem('🎨', 'Beautiful Design', 'Glassmorphism UI with dark theme and smooth animations'),
              _buildFeatureItem('⚙️', 'Customizable Settings', 'Personalize your experience with extensive settings'),
              _buildFeatureItem('🔍', 'Smart Search', 'Find your games quickly with advanced search and filters'),
              _buildFeatureItem('📊', 'Game Statistics', 'Track your gaming history and preferences'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Awesome!',
              style: TextStyle(color: AppColors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.lightBeige.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder(AppColors.redOrange),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.cleaning_services,
              color: AppColors.redOrange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Clear Cache',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'This will clear temporary files and free up storage space. Your saved games and settings will not be affected.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.lightBeige.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.lightBeige.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performCacheClear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redOrange,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  void _performCacheClear() {
    // Simulate cache clearing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cache cleared successfully!'),
        backgroundColor: AppColors.redOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Freed 2.3 MB',
          textColor: AppColors.onPrimary,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showSupportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: Border.all(
            color: AppColors.glassBorder(AppColors.golden),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightBeige.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.support_agent,
                    color: AppColors.golden,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Contact Support',
                    style: AppTextStyles.headlineMedium,
                  ),
                ],
              ),
            ),
            
            // Support options
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSupportOption(
                    Icons.email,
                    'Send Email',
                    'Get help via email support',
                    () {
                      Navigator.pop(context);
                      _showComingSoon('Email support');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSupportOption(
                    Icons.bug_report,
                    'Report Bug',
                    'Report issues or bugs',
                    () {
                      Navigator.pop(context);
                      _showComingSoon('Bug reporting');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSupportOption(
                    Icons.lightbulb,
                    'Suggest Feature',
                    'Share your ideas for new features',
                    () {
                      Navigator.pop(context);
                      _showComingSoon('Feature suggestions');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSupportOption(
                    Icons.help,
                    'FAQ & Help',
                    'Browse frequently asked questions',
                    () {
                      Navigator.pop(context);
                      _showComingSoon('FAQ section');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.glassContainer(
            color: AppColors.lightBeige,
            borderRadius: 15,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.lightBeige, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.lightBeige.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.lightBeige.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder(AppColors.yellow),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.star,
              color: AppColors.yellow,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Rate Spree Party',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Love using Spree Party? Your rating helps us reach more party enthusiasts!',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.lightBeige.withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: AppColors.yellow,
                  size: 32,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Maybe Later',
              style: TextStyle(color: AppColors.lightBeige.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Thank you! Opening App Store...'),
                  backgroundColor: AppColors.yellow,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.glassBorder(AppColors.golden),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.upcoming,
              color: AppColors.golden,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Coming Soon',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          '$feature will be available in a future update. We\'re working hard to bring you new features!',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.lightBeige.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: TextStyle(color: AppColors.golden),
            ),
          ),
        ],
      ),
    );
  }
}