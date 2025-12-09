import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/game_data.dart';
import '../services/claude_api_service.dart';
import '../utils/app_utils.dart';
import 'game_result_screen.dart';

class GameGenerationScreen extends StatefulWidget {
  final GameSettings settings;

  const GameGenerationScreen({
    super.key,
    required this.settings,
  });

  @override
  State<GameGenerationScreen> createState() => _GameGenerationScreenState();
}

class _GameGenerationScreenState extends State<GameGenerationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  
  final ClaudeApiService _apiService = ClaudeApiService();
  bool _isGenerating = true;
  String _statusText = 'Analyzing your preferences...';

  final List<String> _loadingMessages = [
    'Analyzing your preferences...',
    'Consulting with AI party expert...',
    'Creating something amazing...',
    'Adding the fun factor...',
    'Almost ready to party!',
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeIn,
    ));

    _startAnimations();
    _startMessageRotation();
    _generateGame();
  }

  void _startAnimations() {
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _startMessageRotation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isGenerating) {
        setState(() {
          _currentMessageIndex = 
              (_currentMessageIndex + 1) % _loadingMessages.length;
          _statusText = _loadingMessages[_currentMessageIndex];
        });
        _startMessageRotation();
      }
    });
  }

  Future<void> _generateGame() async {
    try {
      // Add minimum delay for better UX
      await Future.delayed(const Duration(seconds: 3));
      
      // Convert GameSettings from models/game_data.dart to the format expected by API service
      final apiSettings = ClaudeGameSettings(
        gameType: widget.settings.gameType,
        playerCount: widget.settings.playerCount,
        ageGroup: widget.settings.ageGroup,
        duration: widget.settings.duration,
        difficulty: widget.settings.difficulty,
        location: widget.settings.location,
        theme: widget.settings.theme,
      );
      
      final gameData = await _apiService.generateGame(apiSettings);
      
      if (!mounted) return;
      
      if (gameData != null) {
        // Save to history
        await _saveToHistory(gameData);
        
        // Navigate to result
        Navigator.pushReplacement(
          context,
          AppAnimations.fadeTransition(
            page: GameResultScreen(gameData: gameData),
          ),
        );
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      if (!mounted) return;
      print('Error generating game: $e');
      _showErrorDialog();
    }
  }

  Future<void> _saveToHistory(GameData gameData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('game_history') ?? '[]';
      final history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
      
      history.insert(0, gameData.toJson());
      
      // Keep only last 50 games
      if (history.length > 50) {
        history.removeRange(50, history.length);
      }
      
      await prefs.setString('game_history', jsonEncode(history));
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  void _showErrorDialog() {
    setState(() {
      _isGenerating = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBlue,
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.redOrange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Generation Failed',
              style: TextStyle(color: AppColors.lightBeige),
            ),
          ],
        ),
        content: Text(
          'We couldn\'t generate your game right now. Please check your internet connection and try again.',
          style: TextStyle(
            color: AppColors.lightBeige.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Go Back',
              style: TextStyle(
                color: AppColors.lightBeige.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isGenerating = true;
                _currentMessageIndex = 0;
                _statusText = _loadingMessages[0];
              });
              _startMessageRotation();
              _generateGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
                // Header
                _buildHeader(),
                
                // Main content
                Expanded(
                  child: _isGenerating 
                      ? _buildGeneratingContent()
                      : const SizedBox.shrink(),
                ),
                
                // Bottom info
                _buildBottomInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.lightBeige,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Generating ${widget.settings.gameType}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingContent() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated AI icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: GlassContainer(
                  color: AppColors.primary,
                  width: 120,
                  height: 120,
                  borderRadius: 30,
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Status text
          AnimatedSwitcher(
            duration: AppAnimations.normal,
            child: Text(
              _statusText,
              key: ValueKey(_statusText),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Our AI is crafting the perfect game for your party!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.lightBeige.withOpacity(0.7),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Loading indicator
          const LoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GlassContainer(
        color: AppColors.lightBeige,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Game Settings:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.lightBeige,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingRow('Players', widget.settings.playerCount),
            _buildSettingRow('Age Group', widget.settings.ageGroup),
            _buildSettingRow('Duration', '${widget.settings.duration} minutes'),
            _buildSettingRow('Difficulty', widget.settings.difficulty),
            _buildSettingRow('Location', widget.settings.location),
            if (widget.settings.theme != null)
              _buildSettingRow('Theme', widget.settings.theme!),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightBeige.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightBeige,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}