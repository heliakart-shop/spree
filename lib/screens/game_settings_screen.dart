import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/game_data.dart';
import '../utils/app_utils.dart';
import 'game_generation_screen.dart';

class GameSettingsScreen extends StatefulWidget {
  final String gameType;

  const GameSettingsScreen({
    super.key,
    required this.gameType,
  });

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Settings values
  String _selectedPlayerCount = PlayerCounts.medium;
  String _selectedAgeGroup = AgeGroups.adults;
  int _duration = 15;
  String _selectedDifficulty = DifficultyLevels.medium;
  String _selectedLocation = Locations.indoor;
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: AppAnimations.normal,
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

  void _generateGame() {
    AppUtils.lightHaptic();
    
    final settings = GameSettings(
      gameType: widget.gameType,
      playerCount: _selectedPlayerCount,
      ageGroup: _selectedAgeGroup,
      duration: _duration,
      difficulty: _selectedDifficulty,
      location: _selectedLocation,
      theme: _selectedTheme,
    );

    AppUtils.navigateToPage(
      context,
      GameGenerationScreen(settings: settings),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameType),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 32),
                
                // Settings sections
                _buildPlayerCountSection(),
                const SizedBox(height: 24),
                
                _buildAgeGroupSection(),
                const SizedBox(height: 24),
                
                _buildDurationSection(),
                const SizedBox(height: 24),
                
                _buildDifficultySection(),
                const SizedBox(height: 24),
                
                _buildLocationSection(),
                const SizedBox(height: 24),
                
                _buildThemeSection(),
                const SizedBox(height: 40),
                
                // Generate button
                _buildGenerateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customize Your Game',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set your preferences to generate the perfect ${widget.gameType.toLowerCase()} for your party!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.lightBeige.withOpacity(0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCountSection() {
    return _buildSettingsSection(
      title: 'Number of Players',
      icon: Icons.group,
      child: _buildChipSelection(
        options: PlayerCounts.all,
        selectedValue: _selectedPlayerCount,
        onSelected: (value) {
          setState(() {
            _selectedPlayerCount = value;
          });
        },
      ),
    );
  }

  Widget _buildAgeGroupSection() {
    return _buildSettingsSection(
      title: 'Age Group',
      icon: Icons.cake,
      child: _buildChipSelection(
        options: AgeGroups.all,
        selectedValue: _selectedAgeGroup,
        onSelected: (value) {
          setState(() {
            _selectedAgeGroup = value;
          });
        },
      ),
    );
  }

  Widget _buildDurationSection() {
    return _buildSettingsSection(
      title: 'Duration',
      icon: Icons.timer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_duration} minutes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.lightBeige.withOpacity(0.3),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              onChanged: (value) {
                setState(() {
                  _duration = value.round();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5 min',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.6),
                ),
              ),
              Text(
                '60 min',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection() {
    return _buildSettingsSection(
      title: 'Difficulty Level',
      icon: Icons.trending_up,
      child: _buildChipSelection(
        options: DifficultyLevels.all,
        selectedValue: _selectedDifficulty,
        onSelected: (value) {
          setState(() {
            _selectedDifficulty = value;
          });
        },
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildSettingsSection(
      title: 'Location',
      icon: Icons.location_on,
      child: _buildChipSelection(
        options: Locations.all,
        selectedValue: _selectedLocation,
        onSelected: (value) {
          setState(() {
            _selectedLocation = value;
          });
        },
      ),
    );
  }

  Widget _buildThemeSection() {
    return _buildSettingsSection(
      title: 'Theme (Optional)',
      icon: Icons.palette,
      child: _buildChipSelection(
        options: GameThemes.all,
        selectedValue: _selectedTheme,
        onSelected: (value) {
          setState(() {
            _selectedTheme = value == _selectedTheme ? null : value;
          });
        },
        allowNone: true,
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return GlassContainer(
      color: AppColors.lightBeige,
      padding: const EdgeInsets.all(20),
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildChipSelection({
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
    bool allowNone = false,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return GestureDetector(
          onTap: () {
            AppUtils.selectionHaptic();
            onSelected(option);
          },
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.lightBeige.withOpacity(0.1),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primary
                    : AppColors.lightBeige.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected 
                    ? AppColors.primary
                    : AppColors.lightBeige.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton() {
    return Column(
      children: [
        CustomButton(
          text: 'Generate ${widget.gameType}',
          onPressed: _generateGame,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        Text(
          'AI will create a unique game based on your preferences',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.lightBeige.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}