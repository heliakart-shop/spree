import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AIGeneratorScreen extends StatefulWidget {
  const AIGeneratorScreen({super.key});

  @override
  State<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
}

class _AIGeneratorScreenState extends State<AIGeneratorScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Form state
  String selectedType = 'Games';
  String selectedDifficulty = 'Medium';
  int participantCount = 5;
  String selectedTheme = 'General';
  int duration = 15;
  String selectedAge = 'Adults (18+)';
  bool isGenerating = false;

  final List<String> gameTypes = ['Games', 'Contests', 'Challenges', 'Icebreakers'];
  final List<String> difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];
  final List<String> themes = [
    'General',
    'Birthday Party',
    'Corporate Event',
    'Holiday Party',
    'Team Building',
    'Wedding Reception',
    'Bachelor/Bachelorette',
    'Kids Party',
    'Sports Theme',
    'Movie Night',
  ];
  final List<String> ageGroups = [
    'Kids (5-12)',
    'Teens (13-17)',
    'Adults (18+)',
    'Mixed Ages',
    'Seniors (50+)',
  ];

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

  void _generateGames() async {
    setState(() {
      isGenerating = true;
    });

    // Simulate AI generation process
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    setState(() {
      isGenerating = false;
    });

    // Show generated results
    _showGeneratedResults();
  }

  void _showGeneratedResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              border: Border.all(
                color: AppColors.glassBorder(AppColors.yellow),
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
                        Icons.auto_awesome,
                        color: AppColors.yellow,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Generated $selectedType',
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
                
                // Generated content
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildGameCard(index);
                    },
                  ),
                ),
                
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _generateGames();
                          },
                          icon: Icon(Icons.refresh, color: AppColors.yellow),
                          label: Text(
                            'Generate More',
                            style: TextStyle(color: AppColors.yellow),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.yellow),
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
                            _showSavedMessage();
                          },
                          icon: const Icon(Icons.bookmark_add),
                          label: const Text('Save All'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.yellow,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameCard(int index) {
    final games = [
      {
        'title': 'Musical Memories Challenge',
        'description': 'Players listen to song snippets and must guess the year, artist, and share a memory associated with that song. Each correct guess earns points, and sharing a personal memory doubles the score!',
        'duration': '10-15 min',
        'players': '$participantCount players',
        'difficulty': selectedDifficulty,
        'materials': 'Music playlist, score sheet',
      },
      {
        'title': 'Story Building Relay',
        'description': 'Each player adds one sentence to create a collaborative story. Twist: every 3rd person must include a random word drawn from a hat. The story gets wilder with each round!',
        'duration': '15-20 min',
        'players': '$participantCount players',
        'difficulty': selectedDifficulty,
        'materials': 'Paper, pen, word cards',
      },
      {
        'title': 'Emotion Charades Plus',
        'description': 'Act out movies, but you can only express emotions - no actions allowed. Other players guess both the emotion and the movie. Perfect for dramatic friends!',
        'duration': '20-25 min',
        'players': '$participantCount players',
        'difficulty': selectedDifficulty,
        'materials': 'Movie cards, timer',
      },
    ];

    final game = games[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.glassContainer(
        color: AppColors.golden,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  game['title']!,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.golden,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.golden.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  game['difficulty']!,
                  style: TextStyle(
                    color: AppColors.golden,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            game['description']!,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.4,
              color: AppColors.lightBeige.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          
          // Materials needed
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inventory,
                  size: 16,
                  color: AppColors.lightBeige.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  'Materials: ',
                  style: TextStyle(
                    color: AppColors.lightBeige.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    game['materials']!,
                    style: TextStyle(
                      color: AppColors.lightBeige.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.schedule, game['duration']!),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.group, game['players']!),
              const Spacer(),
              IconButton(
                onPressed: () => _saveGame(game['title']!),
                icon: Icon(
                  Icons.bookmark_outline,
                  color: AppColors.golden,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => _shareGame(game['title']!),
                icon: Icon(
                  Icons.share,
                  color: AppColors.golden,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
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
            size: 14,
            color: AppColors.lightBeige.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppColors.lightBeige.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _saveGame(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title saved to your collection!'),
        backgroundColor: AppColors.golden,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _shareGame(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $title...'),
        backgroundColor: AppColors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSavedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All games saved to your collection!'),
        backgroundColor: AppColors.yellow,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
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
                
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('What would you like to create?'),
                        _buildGameTypeSelector(),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Party Details'),
                        _buildPartyDetails(),
                        const SizedBox(height: 24),
                        
                        _buildSectionTitle('Preferences'),
                        _buildPreferences(),
                        const SizedBox(height: 40),
                        
                        // Generate button
                        _buildGenerateButton(),
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
            Icons.auto_awesome,
            color: AppColors.yellow,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'AI Generator',
            style: AppTextStyles.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildGameTypeSelector() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gameTypes.length,
        itemBuilder: (context, index) {
          final type = gameTypes[index];
          final isSelected = selectedType == type;
          
          return GestureDetector(
            onTap: () => setState(() => selectedType = type),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.glassContainer(
                color: isSelected ? AppColors.yellow : AppColors.lightBeige,
                borderRadius: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getTypeIcon(type),
                    size: 32,
                    color: isSelected ? AppColors.yellow : AppColors.lightBeige,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? AppColors.yellow : AppColors.lightBeige,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Games':
        return Icons.games;
      case 'Contests':
        return Icons.emoji_events;
      case 'Challenges':
        return Icons.psychology;
      case 'Icebreakers':
        return Icons.ac_unit;
      default:
        return Icons.games;
    }
  }

  Widget _buildPartyDetails() {
    return Column(
      children: [
        _buildSlider(
          label: 'Participants',
          value: participantCount.toDouble(),
          min: 2,
          max: 20,
          divisions: 18,
          onChanged: (value) => setState(() => participantCount = value.round()),
          displayValue: '$participantCount people',
        ),
        const SizedBox(height: 20),
        _buildSlider(
          label: 'Duration',
          value: duration.toDouble(),
          min: 5,
          max: 60,
          divisions: 11,
          onChanged: (value) => setState(() => duration = value.round()),
          displayValue: '$duration minutes',
        ),
        const SizedBox(height: 20),
        _buildDropdown(
          label: 'Age Group',
          value: selectedAge,
          items: ageGroups,
          onChanged: (value) => setState(() => selectedAge = value!),
        ),
        const SizedBox(height: 20),
        _buildDropdown(
          label: 'Theme',
          value: selectedTheme,
          items: themes,
          onChanged: (value) => setState(() => selectedTheme = value!),
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return _buildDropdown(
      label: 'Difficulty Level',
      value: selectedDifficulty,
      items: difficulties,
      onChanged: (value) => setState(() => selectedDifficulty = value!),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                displayValue,
                style: TextStyle(
                  color: AppColors.lightBeige,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.lightBeige,
              inactiveTrackColor: AppColors.lightBeige.withOpacity(0.3),
              thumbColor: AppColors.lightBeige,
              overlayColor: AppColors.lightBeige.withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassContainer(
        color: AppColors.lightBeige,
        borderRadius: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
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

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isGenerating ? null : _generateGames,
        icon: isGenerating
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                ),
              )
            : Icon(Icons.auto_awesome),
        label: Text(isGenerating ? 'Generating with AI...' : 'Generate with AI'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}