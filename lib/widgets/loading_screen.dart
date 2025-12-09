import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingScreen extends StatelessWidget {
  final AnimationController rotationController;
  final double progress;

  const LoadingScreen({
    super.key,
    required this.rotationController,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSpinner(),
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 30),
              _buildProgressBar(),
              const SizedBox(height: 20),
              _buildPercentage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpinner() {
    return AnimatedBuilder(
      animation: rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotationController.value * 2 * 3.14159,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: AppGradients.primaryGradient,
              border: Border.all(
                color: AppColors.glassBorder(AppColors.yellow),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellow.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: AppColors.orange.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration,
              size: 60,
              color: AppColors.darkBlue,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: const Text(
        'Initializing...',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 250,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: AppColors.glassBackground(AppColors.lightBeige, 0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
        ),
      ),
    );
  }

  Widget _buildPercentage() {
    return Text(
      '${(progress * 100).clamp(0, 100).toInt()}%',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.lightBeige.withOpacity(0.8),
      ),
    );
  }
}
