import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeIn,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAgeRestrictionSection(),
                        const SizedBox(height: 32),
                        _buildSection(
                          title: 'Privacy Policy',
                          icon: Icons.privacy_tip,
                          content: _buildPrivacyContent(),
                        ),
                        const SizedBox(height: 24),
                      ],
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.lightBeige,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: AppDecorations.glassContainer(
              color: AppColors.golden,
              borderRadius: 12,
            ),
            child: const Icon(
              Icons.shield,
              color: AppColors.golden,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Policy',
                  style: AppTextStyles.headlineMedium,
                ),
                Text(
                  'Your data, your rights',
                  style: TextStyle(
                    color: AppColors.lightBeige.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeRestrictionSection() {
    return GlassContainer(
      color: AppColors.redOrange,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.redOrange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.redOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.redOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.redOrange.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            '21+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.redOrange,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Age Restriction',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: 20,
                            color: AppColors.lightBeige,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'This application is intended for users aged 21 and over.',
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Spree Game may contain content related to adult party activities, drinking games, and entertainment that is only suitable for adults. By using this application, you confirm that you are at least 21 years of age.',
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.5,
              color: AppColors.lightBeige.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.lightBeige,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please drink responsibly and never drink and drive.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return GlassContainer(
      color: AppColors.lightBeige,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.lightBeige,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPrivacyItem(
          title: 'Information We Collect',
          content:
              'Spree Game is designed with your privacy in mind. We do not collect, store, or share any personal information. All game data is stored locally on your device.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'AI Processing',
          content:
              'When you generate games using our AI features, your prompts are sent to Claude AI (Anthropic) for processing. We do not store these prompts or the generated content on our servers.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'Local Storage',
          content:
              'All your saved games, settings, and preferences are stored locally on your device. This data is never transmitted to our servers or third parties.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'No Location Tracking',
          content:
              'We do not track, collect, or store your location data. The app does not require or use location services.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'No Email Required',
          content:
              'You can use Spree Game without providing an email address or creating an account. No registration is required.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'Third-Party Services',
          content:
              'This app uses Claude AI API (Anthropic) for generating game content. Please refer to Anthropic\'s privacy policy for information about how they handle data.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'Data Security',
          content:
              'Since we don\'t collect or transmit personal data, there is minimal risk to your privacy. All data remains on your device under your control.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'Children\'s Privacy',
          content:
              'Spree Game is not intended for users under 21 years of age. We do not knowingly collect information from anyone under 21.',
        ),
        const SizedBox(height: 20),
        _buildPrivacyItem(
          title: 'Changes to Privacy Policy',
          content:
              'We may update this privacy policy from time to time. Any changes will be reflected in the app. Continued use of the app constitutes acceptance of any changes.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your privacy is our priority. Enjoy the app with peace of mind!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightBeige,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyItem({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.lightBeige,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.5,
            color: AppColors.lightBeige.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}
