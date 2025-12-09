import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class NetworkErrorDialog extends StatelessWidget {
  const NetworkErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: AppDecorations.glassContainer(
              color: AppColors.lightBeige,
              borderRadius: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildErrorIcon(),
                const SizedBox(height: 24),
                _buildErrorTitle(),
                const SizedBox(height: 16),
                _buildErrorMessage(),
                const SizedBox(height: 32),
                _buildExitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.redOrange.withOpacity(0.2),
            AppColors.redOrange.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.redOrange,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.wifi_off_rounded,
        size: 40,
        color: AppColors.redOrange,
      ),
    );
  }

  Widget _buildErrorTitle() {
    return const Text(
      'No Internet Connection',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue,
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      'Please check your internet connection and try again.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.darkBlue.withOpacity(0.7),
      ),
    );
  }

  Widget _buildExitButton() {
    return ElevatedButton(
      onPressed: () => SystemNavigator.pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.redOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Exit',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
