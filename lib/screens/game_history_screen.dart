import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/game_data.dart';
import '../utils/app_utils.dart';
import 'game_result_screen.dart';

class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<GameData> _gameHistory = [];
  bool _isLoading = true;

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

    _loadGameHistory();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadGameHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('game_history') ?? '[]';
      final historyList = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
      
      setState(() {
        _gameHistory = historyList
            .map((json) => GameData.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading game history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await AppUtils.showConfirmDialog(
      context,
      'Clear History',
      'Are you sure you want to clear all game history? This action cannot be undone.',
      confirmText: 'Clear',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('game_history');
      setState(() {
        _gameHistory.clear();
      });
      
      if (mounted) {
        AppUtils.showSnackBar(
          context,
          'Game history cleared successfully',
          backgroundColor: AppColors.primary.withOpacity(0.9),
          textColor: AppColors.onPrimary,
        );
      }
    }
  }

  void _viewGame(GameData gameData) {
    AppUtils.navigateToPage(
      context,
      GameResultScreen(gameData: gameData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_gameHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: 'Clear history',
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: _isLoading
              ? const Center(child: LoadingIndicator())
              : _gameHistory.isEmpty
                  ? _buildEmptyState()
                  : _buildHistoryList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            color: AppColors.lightBeige,
            width: 100,
            height: 100,
            borderRadius: 25,
            child: const Icon(
              Icons.history,
              size: 50,
              color: AppColors.lightBeige,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No Games Yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Generate your first party game and it will appear here for easy access later!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.lightBeige.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Create First Game',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _gameHistory.length,
      itemBuilder: (context, index) {
        final game = _gameHistory[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGameCard(game, index),
        );
      },
    );
  }

  Widget _buildGameCard(GameData game, int index) {
    return GestureDetector(
      onTap: () => _viewGame(game),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        child: GlassContainer(
          color: AppColors.lightBeige,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      game.gameType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppUtils.formatDate(game.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.lightBeige.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                game.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              
              // Description
              Text(
                game.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightBeige.withOpacity(0.8),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              
              // Game info
              Row(
                children: [
                  _buildInfoChip(Icons.group, game.playerCount),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.timer, '${game.duration} min'),
                  const SizedBox(width: 12),
                  _buildInfoChip(Icons.trending_up, game.difficulty),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.lightBeige.withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightBeige.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.lightBeige.withOpacity(0.7),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightBeige.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}