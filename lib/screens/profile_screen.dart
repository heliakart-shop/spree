import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _cardController;
  late AnimationController _achievementController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardAnimation;

  // Sample user data
  final Map<String, dynamic> userData = {
    'name': 'Party Master',
    'email': 'partymaster@example.com',
    'joinDate': DateTime.now().subtract(const Duration(days: 45)),
    'level': 8,
    'experience': 3750,
    'nextLevelExp': 4000,
    'gamesGenerated': 67,
    'favoriteGames': 23,
    'partiesHosted': 12,
    'totalPlaytime': 480, // minutes
    'streakDays': 7,
    'preferredGameType': 'Games',
    'averageRating': 4.8,
  };

  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'First Generation',
      'description': 'Generated your first game',
      'icon': Icons.auto_awesome,
      'color': AppColors.yellow,
      'unlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 45)),
      'rarity': 'Common',
    },
    {
      'title': 'Party Starter',
      'description': 'Generated 10 games',
      'icon': Icons.celebration,
      'color': AppColors.orange,
      'unlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 30)),
      'rarity': 'Common',
    },
    {
      'title': 'Creative Genius',
      'description': 'Generated 50 games',
      'icon': Icons.psychology,
      'color': AppColors.golden,
      'unlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 5)),
      'rarity': 'Rare',
    },
    {
      'title': 'Favorite Collector',
      'description': 'Saved 20 favorite games',
      'icon': Icons.favorite,
      'color': AppColors.redOrange,
      'unlocked': true,
      'unlockedDate': DateTime.now().subtract(const Duration(days: 10)),
      'rarity': 'Uncommon',
    },
    {
      'title': 'Weekly Warrior',
      'description': 'Used the app 7 days in a row',
      'icon': Icons.local_fire_department,
      'color': AppColors.lightBeige,
      'unlocked': true,
      'unlockedDate': DateTime.now(),
      'rarity': 'Uncommon',
    },
    {
      'title': 'Master Host',
      'description': 'Host 25 successful parties',
      'icon': Icons.emoji_events,
      'color': AppColors.brown,
      'unlocked': false,
      'progress': 0.48, // 12/25
      'rarity': 'Epic',
    },
    {
      'title': 'AI Whisperer',
      'description': 'Generate 100 unique games',
      'icon': Icons.smart_toy,
      'color': AppColors.yellow,
      'unlocked': false,
      'progress': 0.67, // 67/100
      'rarity': 'Epic',
    },
    {
      'title': 'Legend',
      'description': 'Reach level 20',
      'icon': Icons.military_tech,
      'color': AppColors.golden,
      'unlocked': false,
      'progress': 0.4, // 8/20
      'rarity': 'Legendary',
    },
  ];

  final List<Map<String, dynamic>> recentActivity = [
    {
      'type': 'generated',
      'title': 'Generated "Musical Quiz Battle"',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.auto_awesome,
      'color': AppColors.yellow,
    },
    {
      'type': 'saved',
      'title': 'Saved "Story Building Relay"',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.bookmark_add,
      'color': AppColors.orange,
    },
    {
      'type': 'played',
      'title': 'Played "Trivia Championship"',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.play_circle,
      'color': AppColors.golden,
    },
    {
      'type': 'achievement',
      'title': 'Unlocked "Weekly Warrior"',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.emoji_events,
      'color': AppColors.lightBeige,
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _achievementController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      parent: _cardController,
      curve: AppAnimations.easeOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _achievementController,
      curve: AppAnimations.elastic,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _cardController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _achievementController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatPlaytime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }
    return '${minutes}m';
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return AppColors.lightBeige;
      case 'Uncommon':
        return AppColors.orange;
      case 'Rare':
        return AppColors.golden;
      case 'Epic':
        return AppColors.redOrange;
      case 'Legendary':
        return AppColors.yellow;
      default:
        return AppColors.lightBeige;
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
                
                // Profile content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile info card
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildProfileInfo(),
                        ),
                        const SizedBox(height: 24),
                        
                        // Level progress
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildLevelProgress(),
                        ),
                        const SizedBox(height: 24),
                        
                        // Stats grid
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildStatsGrid(),
                        ),
                        const SizedBox(height: 32),
                        
                        // Recent activity
                        _buildSectionTitle('Recent Activity', Icons.history),
                        _buildRecentActivity(),
                        const SizedBox(height: 32),
                        
                        // Achievements
                        _buildSectionTitle('Achievements', Icons.emoji_events),
                        _buildAchievements(),
                        
                        const SizedBox(height: 40),
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
            AppColors.lightBeige.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
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
              color: AppColors.lightBeige,
              borderRadius: 12,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.lightBeige,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Profile',
                style: AppTextStyles.headlineMedium,
              ),
              Text(
                'Gaming statistics & achievements',
                style: TextStyle(
                  color: AppColors.lightBeige.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _showEditProfile();
            },
            icon: Icon(
              Icons.edit,
              color: AppColors.lightBeige.withOpacity(0.7),
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

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 20,
      ),
      child: Column(
        children: [
          // Avatar and basic info
          Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.yellow,
                      AppColors.golden,
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.glassBorder(AppColors.yellow),
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(width: 20),
              
              // Name and basic stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['name'],
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 22,
                        color: AppColors.lightBeige,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData['email'],
                      style: TextStyle(
                        color: AppColors.lightBeige.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightBeige.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.lightBeige,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Joined ${_formatDate(userData['joinDate'])}',
                            style: TextStyle(
                              color: AppColors.lightBeige,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('Level', '${userData['level']}', Icons.star),
              _buildQuickStat('Streak', '${userData['streakDays']} days', Icons.local_fire_department),
              _buildQuickStat('Rating', '${userData['averageRating']}⭐', Icons.grade),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.lightBeige,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 18,
            color: AppColors.lightBeige,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.lightBeige.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgress() {
    final progress = userData['experience'] / userData['nextLevelExp'];
    final expToNext = userData['nextLevelExp'] - userData['experience'];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.glassContainer(
        color: AppColors.golden,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${userData['level']}',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 20,
                      color: AppColors.golden,
                    ),
                  ),
                  Text(
                    '$expToNext XP to next level',
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.golden.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${userData['experience']} XP',
                  style: TextStyle(
                    color: AppColors.golden,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.golden,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).round()}% complete',
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: 'Games Generated',
          value: '${userData['gamesGenerated']}',
          icon: Icons.auto_awesome,
          color: AppColors.yellow,
        ),
        _buildStatCard(
          title: 'Favorites',
          value: '${userData['favoriteGames']}',
          icon: Icons.favorite,
          color: AppColors.redOrange,
        ),
        _buildStatCard(
          title: 'Parties Hosted',
          value: '${userData['partiesHosted']}',
          icon: Icons.celebration,
          color: AppColors.orange,
        ),
        _buildStatCard(
          title: 'Total Playtime',
          value: _formatPlaytime(userData['totalPlaytime']),
          icon: Icons.schedule,
          color: AppColors.brown,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        color: color,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      children: recentActivity.map((activity) => _buildActivityItem(activity)).toList(),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        color: activity['color'],
        borderRadius: 12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              activity['title'],
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _getTimeAgo(activity['time']),
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return ScaleTransition(
      scale: _cardAnimation,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return _buildAchievementCard(achievement, index);
        },
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement, int index) {
    final isUnlocked = achievement['unlocked'];
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 50)),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showAchievementDetails(achievement);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.glassContainer(
            color: isUnlocked ? achievement['color'] : AppColors.lightBeige,
            borderRadius: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    achievement['icon'],
                    color: isUnlocked ? achievement['color'] : AppColors.lightBeige.withOpacity(0.5),
                    size: 24,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getRarityColor(achievement['rarity']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      achievement['rarity'],
                      style: TextStyle(
                        color: _getRarityColor(achievement['rarity']),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                achievement['title'],
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? achievement['color'] : AppColors.lightBeige.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                achievement['description'],
                style: TextStyle(
                  color: AppColors.lightBeige.withOpacity(0.7),
                  fontSize: 12,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              
              // Progress bar for locked achievements
              if (!isUnlocked && achievement.containsKey('progress'))
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: achievement['progress'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightBeige.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(achievement['progress'] * 100).round()}%',
                      style: TextStyle(
                        color: AppColors.lightBeige.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              
              // Unlocked indicator
              if (isUnlocked)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: achievement['color'],
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Unlocked',
                      style: TextStyle(
                        color: achievement['color'],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: Border.all(
            color: AppColors.glassBorder(achievement['color']),
            width: 1,
          ),
        ),
        child: Column(
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
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Achievement icon and rarity
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: achievement['unlocked'] 
                            ? LinearGradient(
                                colors: [achievement['color'], achievement['color'].withOpacity(0.7)]
                              )
                            : null,
                        color: achievement['unlocked'] ? null : AppColors.lightBeige.withOpacity(0.3),
                        border: Border.all(
                          color: achievement['unlocked'] 
                              ? achievement['color'] 
                              : AppColors.lightBeige.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        achievement['icon'],
                        size: 40,
                        color: achievement['unlocked'] 
                            ? AppColors.onPrimary 
                            : AppColors.lightBeige.withOpacity(0.5),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Rarity badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getRarityColor(achievement['rarity']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        achievement['rarity'],
                        style: TextStyle(
                          color: _getRarityColor(achievement['rarity']),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Title and description
                    Text(
                      achievement['title'],
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: achievement['unlocked'] ? achievement['color'] : AppColors.lightBeige,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      achievement['description'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.lightBeige.withOpacity(0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status and progress
                    if (achievement['unlocked'])
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.glassContainer(
                          color: achievement['color'],
                          borderRadius: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: achievement['color'],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Text(
                                  'Unlocked!',
                                  style: TextStyle(
                                    color: achievement['color'],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                if (achievement.containsKey('unlockedDate'))
                                  Text(
                                    _getTimeAgo(achievement['unlockedDate']),
                                    style: TextStyle(
                                      color: AppColors.lightBeige.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.glassContainer(
                          color: AppColors.lightBeige,
                          borderRadius: 15,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: AppColors.lightBeige,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Not yet unlocked',
                                  style: TextStyle(
                                    color: AppColors.lightBeige,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            if (achievement.containsKey('progress'))
                              Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.darkBlue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: achievement['progress'],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.lightBeige,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(achievement['progress'] * 100).round()}% Complete',
                                    style: TextStyle(
                                      color: AppColors.lightBeige,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: achievement['unlocked'] ? achievement['color'] : AppColors.lightBeige,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: Border.all(
            color: AppColors.glassBorder(AppColors.lightBeige),
            width: 1,
          ),
        ),
        child: Column(
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
                    Icons.edit,
                    color: AppColors.lightBeige,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Profile',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.lightBeige.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Edit form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar selection
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Avatar customization coming soon!'),
                              backgroundColor: AppColors.golden,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.yellow, AppColors.golden],
                                ),
                                border: Border.all(
                                  color: AppColors.glassBorder(AppColors.yellow),
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.golden,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.darkBlue,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.onPrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Name field
                    _buildEditField(
                      'Display Name',
                      userData['name'],
                      Icons.person,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Email field
                    _buildEditField(
                      'Email',
                      userData['email'],
                      Icons.email,
                      enabled: false,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Preferred game type
                    _buildDropdownField(
                      'Preferred Game Type',
                      userData['preferredGameType'],
                      ['Games', 'Contests', 'Challenges', 'Mixed'],
                      Icons.games,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Privacy settings
                    Text(
                      'Privacy Settings',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 18,
                        color: AppColors.golden,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildSwitchField(
                      'Public Profile',
                      'Allow others to see your achievements',
                      true,
                      Icons.public,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildSwitchField(
                      'Show Activity',
                      'Display your recent gaming activity',
                      true,
                      Icons.visibility,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Profile updated successfully!'),
                              backgroundColor: AppColors.lightBeige,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBeige,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String value, IconData icon, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: enabled,
          style: TextStyle(color: AppColors.lightBeige),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.lightBeige.withOpacity(0.7)),
            filled: true,
            fillColor: enabled ? AppColors.lightBeige.withOpacity(0.1) : AppColors.darkBlue.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.glassBorder(AppColors.lightBeige),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.glassBorder(AppColors.lightBeige),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightBeige,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          style: TextStyle(color: AppColors.lightBeige),
          dropdownColor: AppColors.darkBlue,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.lightBeige.withOpacity(0.7)),
            filled: true,
            fillColor: AppColors.lightBeige.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.glassBorder(AppColors.lightBeige),
              ),
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (newValue) {
            HapticFeedback.selectionClick();
            // Handle change
          },
        ),
      ],
    );
  }

  Widget _buildSwitchField(String title, String subtitle, bool value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 12,
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
          Switch(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.lightImpact();
              // Handle change
            },
            activeColor: AppColors.lightBeige,
            activeTrackColor: AppColors.lightBeige.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}