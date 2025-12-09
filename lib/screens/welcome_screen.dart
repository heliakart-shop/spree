import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/welcome_page_data.dart';
import 'main_menu_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<WelcomePageData> pages = [
    WelcomePageData(
      icon: Icons.auto_awesome,
      title: 'AI-Powered Entertainment',
      description: 'Generate unique party games and contests tailored to your group using advanced AI technology.',
      color: AppColors.yellow,
    ),
    WelcomePageData(
      icon: Icons.group,
      title: 'Perfect for Any Party',
      description: 'Whether it\'s a birthday, celebration, or casual hangout - create memorable experiences for everyone.',
      color: AppColors.orange,
    ),
    WelcomePageData(
      icon: Icons.settings,
      title: 'Customizable Games',
      description: 'Adjust settings, difficulty, and themes to match your party\'s vibe and your guests\' preferences.',
      color: AppColors.golden,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: AppAnimations.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeIn,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _completeWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      AppAnimations.fadeTransition(page: const MainMenuScreen()),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: AppAnimations.normal,
      curve: AppAnimations.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return _buildWelcomePage(pages[index]);
                        },
                      ),
                    ),
                    _buildBottomSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomePage(WelcomePageData page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with glassmorphism effect
          GlassContainer(
            color: page.color,
            width: 120,
            height: 120,
            borderRadius: 30,
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: AppColors.lightBeige.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Page indicators
          PageIndicator(
            currentPage: currentPage,
            totalPages: pages.length,
          ),
          const SizedBox(height: 32),
          // Buttons
          Row(
            children: [
              if (currentPage < pages.length - 1) ...[
                TextButton(
                  onPressed: _completeWelcome,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightBeige.withOpacity(0.6),
                    ),
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: 'Next',
                  onPressed: _nextPage,
                ),
              ] else  ...[
                TextButton(
                  onPressed: _completeWelcome,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightBeige.withOpacity(0.6),
                    ),
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: 'Start',
                  onPressed: _completeWelcome,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}