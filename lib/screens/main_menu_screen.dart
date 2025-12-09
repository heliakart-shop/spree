import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/menu_item_data.dart';
import '../models/game_data.dart';
import '../utils/app_utils.dart';
import 'game_settings_screen.dart';
import 'game_history_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _headerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  late final List<MenuItemData> menuItems;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeIn,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: AppAnimations.easeOut,
    ));

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: AppAnimations.easeIn,
    ));

    // Initialize menu items with navigation
    menuItems = [
      MenuItemData(
        icon: Icons.games,
        title: 'Party Games',
        description: 'Classic party entertainment',
        color: AppColors.yellow,
        onTap: () => _navigateToGameSettings(GameTypes.partyClassics),
      ),
      MenuItemData(
        icon: Icons.people,
        title: 'Ice Breakers',
        description: 'Break the ice with new friends',
        color: AppColors.orange,
        onTap: () => _navigateToGameSettings(GameTypes.iceBreakers),
      ),
      MenuItemData(
        icon: Icons.group_work,
        title: 'Team Building',
        description: 'Build stronger connections',
        color: AppColors.golden,
        onTap: () => _navigateToGameSettings(GameTypes.teamBuilding),
      ),
      MenuItemData(
        icon: Icons.brush,
        title: 'Creative Games',
        description: 'Unleash your creativity',
        color: AppColors.redOrange,
        onTap: () => _navigateToGameSettings(GameTypes.creative),
      ),
      MenuItemData(
        icon: Icons.fitness_center,
        title: 'Physical Activities',
        description: 'Get moving and active',
        color: AppColors.brown,
        onTap: () => _navigateToGameSettings(GameTypes.physical),
      ),
      MenuItemData(
        icon: Icons.psychology,
        title: 'Mind Games',
        description: 'Challenge your brain',
        color: AppColors.lightBeige,
        onTap: () => _navigateToGameSettings(GameTypes.mindGames),
      ),
    ];

    _startAnimations();
  }

  void _startAnimations() {
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  void _navigateToGameSettings(String gameType) {
    AppUtils.lightHaptic();
    AppUtils.navigateToPage(
      context,
      GameSettingsScreen(gameType: gameType),
    );
  }

  void _navigateToHistory() {
    AppUtils.lightHaptic();
    AppUtils.navigateToPage(
      context,
      const GameHistoryScreen(),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _headerController.dispose();
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
          child: Column(
            children: [
              // Animated Header
              SlideTransition(
                position: _headerSlideAnimation,
                child: FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(context),
                        const SizedBox(height: 40),
                        _buildWelcomeSection(context),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Animated Menu Grid
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildMenuGrid(),
                  ),
                ),
              ),
              
              // Bottom section with additional info
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBottomSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // App logo with pulse animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: const GlassIconContainer(
                icon: Icons.celebration,
                color: AppColors.primary,
                size: 60,
                borderRadius: 18,
                iconSize: 30,
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        
        // App title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GradientText(
                text: 'Spree Party',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'AI Party Games Generator',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.7),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        
        // History button with notification badge
        Stack(
          children: [
            GestureDetector(
              onTap: _navigateToHistory,
              child: GlassContainer(
                color: AppColors.lightBeige,
                width: 50,
                height: 50,
                borderRadius: 15,
                child: const Icon(
                  Icons.history,
                  color: AppColors.lightBeige,
                  size: 24,
                ),
              ),
            ),
            // Small notification dot (you can make this dynamic)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 
        ? 'Good Morning!' 
        : hour < 17 
            ? 'Good Afternoon!' 
            : 'Good Evening!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What kind of fun would you like to create today?',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 24,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Choose a game type below and let AI create the perfect entertainment for your party!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.lightBeige.withOpacity(0.8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return AnimatedMenuCard(
          icon: item.icon,
          title: item.title,
          description: item.description,
          color: item.color,
          onTap: item.onTap,
          delay: Duration(milliseconds: 150 * index),
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Feature highlights
          GlassContainer(
            color: AppColors.lightBeige,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFeatureItem(
                    Icons.auto_awesome,
                    'AI Powered',
                    'Smart game generation',
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.lightBeige.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildFeatureItem(
                    Icons.tune,
                    'Customizable',
                    'Your preferences matter',
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.lightBeige.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildFeatureItem(
                    Icons.group,
                    'For Everyone',
                    'All ages & group sizes',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Version info
          Text(
            'Powered by Claude AI • Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightBeige.withOpacity(0.5),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.lightBeige,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.lightBeige.withOpacity(0.7),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}