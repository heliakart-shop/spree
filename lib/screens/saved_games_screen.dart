import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SavedGamesScreen extends StatefulWidget {
  const SavedGamesScreen({super.key});

  @override
  State<SavedGamesScreen> createState() => _SavedGamesScreenState();
}

class _SavedGamesScreenState extends State<SavedGamesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String selectedFilter = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> filters = ['All', 'Games', 'Contests', 'Challenges', 'Favorites'];

  // Sample saved games data
  final List<Map<String, dynamic>> allSavedGames = [
    {
      'title': 'Musical Memories Challenge',
      'type': 'Games',
      'difficulty': 'Medium',
      'duration': '10-15 min',
      'players': '5 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 2)),
      'color': AppColors.yellow,
      'isFavorite': true,
      'description': 'Players listen to song snippets and must guess the year, artist, and share a memory.',
      'materials': 'Music playlist, score sheet',
      'timesPlayed': 3,
    },
    {
      'title': 'Story Building Relay',
      'type': 'Games',
      'difficulty': 'Easy',
      'duration': '15-20 min',
      'players': '5 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 5)),
      'color': AppColors.orange,
      'isFavorite': false,
      'description': 'Each player adds one sentence to create a collaborative story with random words.',
      'materials': 'Paper, pen, word cards',
      'timesPlayed': 1,
    },
    {
      'title': 'Trivia Championship',
      'type': 'Contests',
      'difficulty': 'Hard',
      'duration': '30 min',
      'players': '8 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 7)),
      'color': AppColors.golden,
      'isFavorite': true,
      'description': 'Ultimate trivia contest with multiple categories and bonus rounds.',
      'materials': 'Question cards, scoreboard',
      'timesPlayed': 5,
    },
    {
      'title': 'Creative Drawing Challenge',
      'type': 'Contests',
      'difficulty': 'Medium',
      'duration': '20 min',
      'players': '6 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 10)),
      'color': AppColors.redOrange,
      'isFavorite': false,
      'description': 'Draw prompts while others guess what you are creating.',
      'materials': 'Paper, pencils, timer',
      'timesPlayed': 2,
    },
    {
      'title': 'Memory Palace Challenge',
      'type': 'Challenges',
      'difficulty': 'Expert',
      'duration': '25 min',
      'players': '4 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 14)),
      'color': AppColors.lightBeige,
      'isFavorite': true,
      'description': 'Test your memory skills with increasingly complex sequences and patterns.',
      'materials': 'Memory cards, timer',
      'timesPlayed': 0,
    },
    {
      'title': 'Icebreaker Bingo',
      'type': 'Games',
      'difficulty': 'Easy',
      'duration': '10 min',
      'players': '10 players',
      'savedDate': DateTime.now().subtract(const Duration(days: 21)),
      'color': AppColors.brown,
      'isFavorite': false,
      'description': 'Find people who match different characteristics on your bingo card.',
      'materials': 'Bingo cards, pens',
      'timesPlayed': 4,
    },
  ];

  List<Map<String, dynamic>> get filteredGames {
    List<Map<String, dynamic>> filtered = allSavedGames;

    // Apply type filter
    if (selectedFilter != 'All') {
      if (selectedFilter == 'Favorites') {
        filtered = filtered.where((game) => game['isFavorite'] == true).toList();
      } else {
        filtered = filtered.where((game) => game['type'] == selectedFilter).toList();
      }
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((game) {
        return game['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
               game['description'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Sort by saved date (newest first)
    filtered.sort((a, b) => b['savedDate'].compareTo(a['savedDate']));

    return filtered;
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      parent: _listController,
      curve: AppAnimations.easeOut,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    if (difference < 7) return "$difference days ago";
    if (difference < 30) return "${(difference / 7).ceil()} weeks ago";
    return "${(difference / 30).ceil()} months ago";
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
                
                // Search and filters
                _buildSearchAndFilters(),
                
                // Stats section
                _buildStatsSection(),
                
                // Games list
                Expanded(
                  child: filteredGames.isEmpty
                      ? _buildEmptyState()
                      : _buildGamesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.lightBeige,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.bookmark,
            color: AppColors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Saved Games',
            style: AppTextStyles.headlineMedium,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: AppDecorations.glassContainer(
              color: AppColors.orange,
              borderRadius: 15,
            ),
            child: Text(
              '${allSavedGames.length} games',
              style: TextStyle(
                color: AppColors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: AppDecorations.glassContainer(
              color: AppColors.lightBeige,
              borderRadius: 15,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: AppColors.lightBeige),
              decoration: InputDecoration(
                hintText: 'Search games...',
                hintStyle: TextStyle(
                  color: AppColors.lightBeige.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.lightBeige.withOpacity(0.7),
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.lightBeige.withOpacity(0.7),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? AppColors.onPrimary : AppColors.lightBeige,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    backgroundColor: AppColors.lightBeige.withOpacity(0.1),
                    selectedColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected 
                            ? AppColors.yellow 
                            : AppColors.lightBeige.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final totalGames = allSavedGames.length;
    final favorites = allSavedGames.where((game) => game['isFavorite']).length;
    final totalPlayed = allSavedGames.fold(0, (sum, game) => sum + (game['timesPlayed'] as int));
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.bookmark,
              title: 'Total',
              value: totalGames.toString(),
              color: AppColors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite,
              title: 'Favorites',
              value: favorites.toString(),
              color: AppColors.redOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.play_circle,
              title: 'Played',
              value: totalPlayed.toString(),
              color: AppColors.golden,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
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
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesList() {
    return SlideTransition(
      position: _slideAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filteredGames.length,
        itemBuilder: (context, index) {
          final game = filteredGames[index];
          return AnimatedScale(
            scale: 1.0,
            duration: Duration(milliseconds: 200 + (index * 50)),
            child: _buildGameCard(game, index),
          );
        },
      ),
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppDecorations.glassContainer(
        color: game['color'],
        borderRadius: 15,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _showGameDetails(game),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game['title'],
                            style: AppTextStyles.headlineMedium.copyWith(
                              fontSize: 18,
                              color: game['color'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(game['savedDate']),
                            style: TextStyle(
                              color: AppColors.lightBeige.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Play count
                    if (game['timesPlayed'] > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: game['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              size: 14,
                              color: game['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${game['timesPlayed']}',
                              style: TextStyle(
                                color: game['color'],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Favorite button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          game['isFavorite'] = !game['isFavorite'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              game['isFavorite'] 
                                  ? 'Added to favorites!' 
                                  : 'Removed from favorites',
                            ),
                            backgroundColor: game['color'],
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        game['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: game['color'],
                        size: 20,
                      ),
                    ),
                    // More menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: game['color'],
                        size: 20,
                      ),
                      color: AppColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: AppColors.glassBorder(game['color']),
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'play',
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow, color: AppColors.lightBeige, size: 16),
                              const SizedBox(width: 8),
                              Text('Play Now', style: TextStyle(color: AppColors.lightBeige)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: AppColors.lightBeige, size: 16),
                              const SizedBox(width: 8),
                              Text('Edit Game', style: TextStyle(color: AppColors.lightBeige)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, color: AppColors.lightBeige, size: 16),
                              const SizedBox(width: 8),
                              Text('Duplicate', style: TextStyle(color: AppColors.lightBeige)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, color: AppColors.lightBeige, size: 16),
                              const SizedBox(width: 8),
                              Text('Share', style: TextStyle(color: AppColors.lightBeige)),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppColors.redOrange, size: 16),
                              const SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: AppColors.redOrange)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        _handleMenuAction(value, game, index);
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  game['description'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.lightBeige.withOpacity(0.8),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Game info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildGameChip(Icons.category, game['type']),
                    _buildGameChip(Icons.signal_cellular_alt, game['difficulty']),
                    _buildGameChip(Icons.schedule, game['duration']),
                    _buildGameChip(Icons.group, game['players']),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.lightBeige.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SlideTransition(
      position: _slideAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: AppDecorations.glassContainer(
                  color: AppColors.orange,
                  borderRadius: 60,
                ),
                child: Icon(
                  searchQuery.isNotEmpty || selectedFilter != 'All' 
                      ? Icons.search_off 
                      : Icons.bookmark_outline,
                  size: 60,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                searchQuery.isNotEmpty || selectedFilter != 'All'
                    ? 'No games found'
                    : 'No saved games yet',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                searchQuery.isNotEmpty || selectedFilter != 'All'
                    ? 'Try adjusting your search or filters'
                    : 'Generate some games and save your favorites here',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (searchQuery.isEmpty && selectedFilter == 'All')
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate Games'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                      selectedFilter = 'All';
                    });
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBeige,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameDetails(Map<String, dynamic> game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.darkBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          border: Border.all(
            color: AppColors.glassBorder(game['color']),
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
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            game['title'],
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: game['color'],
                              fontSize: 24,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: AppColors.lightBeige.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      game['description'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        height: 1.5,
                        color: AppColors.lightBeige.withOpacity(0.9),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Game details
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppDecorations.glassContainer(
                        color: game['color'],
                        borderRadius: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.group, 'Players', game['players']),
                          _buildDetailRow(Icons.schedule, 'Duration', game['duration']),
                          _buildDetailRow(Icons.signal_cellular_alt, 'Difficulty', game['difficulty']),
                          _buildDetailRow(Icons.inventory, 'Materials', game['materials']),
                          if (game['timesPlayed'] > 0)
                            _buildDetailRow(Icons.play_circle, 'Times Played', '${game['timesPlayed']}'),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleMenuAction('share', game, 0);
                            },
                            icon: Icon(Icons.share, color: game['color']),
                            label: Text(
                              'Share',
                              style: TextStyle(color: game['color']),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: game['color']),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleMenuAction('play', game, 0);
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: game['color'],
                              foregroundColor: AppColors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.lightBeige.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.lightBeige,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> game, int index) {
    switch (action) {
      case 'play':
        setState(() {
          game['timesPlayed'] = (game['timesPlayed'] as int) + 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Starting "${game['title']}"... Have fun!'),
            backgroundColor: game['color'],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Rules',
              textColor: AppColors.onPrimary,
              onPressed: () => _showGameDetails(game),
            ),
          ),
        );
        break;
      case 'edit':
        _showComingSoon('Game editing');
        break;
      case 'duplicate':
        setState(() {
          final newGame = Map<String, dynamic>.from(game);
          newGame['title'] = '${game['title']} (Copy)';
          newGame['savedDate'] = DateTime.now();
          newGame['timesPlayed'] = 0;
          allSavedGames.insert(0, newGame);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Game duplicated successfully!'),
            backgroundColor: AppColors.golden,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing "${game['title']}"...'),
            backgroundColor: AppColors.lightBeige,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(game, index);
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> game, int index) {
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
              Icons.delete_outline,
              color: AppColors.redOrange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Game',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${game['title']}"?',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.lightBeige.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.redOrange.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
              setState(() {
                allSavedGames.removeWhere((g) => g['title'] == game['title']);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${game['title']} deleted'),
                  backgroundColor: AppColors.redOrange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: AppColors.onPrimary,
                    onPressed: () {
                      setState(() {
                        allSavedGames.add(game);
                      });
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redOrange,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Delete'),
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
          '$feature will be available in a future update. Stay tuned!',
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