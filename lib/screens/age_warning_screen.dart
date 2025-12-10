import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AgeWarningScreen extends StatefulWidget {
  final Widget nextScreen;

  const AgeWarningScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<AgeWarningScreen> createState() => _AgeWarningScreenState();
}

class _AgeWarningScreenState extends State<AgeWarningScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: AppAnimations.elastic,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _confirmAge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ageConfirmed', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      AppAnimations.fadeTransition(page: widget.nextScreen),
    );
  }

  void _declineAge() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
              Icons.info_outline,
              color: AppColors.redOrange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Age Restriction',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'You must be 21 or older to use this application. The app will now close.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.lightBeige.withOpacity(0.8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Exit the app
              Navigator.of(context).pop();
              // Note: In production, you might want to use SystemNavigator.pop()
              // or a proper app exit mechanism
            },
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.redOrange),
            ),
          ),
        ],
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
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Warning Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GlassContainer(
                      color: AppColors.redOrange,
                      width: 120,
                      height: 120,
                      borderRadius: 30,
                      child: const Icon(
                        Icons.warning_rounded,
                        size: 60,
                        color: AppColors.redOrange,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  const GradientText(
                    text: 'Age Verification',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Warning Message
                  GlassContainer(
                    color: AppColors.lightBeige,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.redOrange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '21+',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.redOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Adults Only',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'This application contains content that may only be suitable for adults aged 21 and over.',
                          style: AppTextStyles.bodyLarge.copyWith(
                            height: 1.5,
                            color: AppColors.lightBeige.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'By continuing, you confirm that you are at least 21 years old.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.4,
                            color: AppColors.lightBeige.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Buttons
                  Column(
                    children: [
                      CustomButton(
                        text: 'I am 21 or older',
                        onPressed: _confirmAge,
                        backgroundColor: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'I am under 21',
                        onPressed: _declineAge,
                        backgroundColor: AppColors.lightBeige.withOpacity(0.2),
                        textColor: AppColors.lightBeige,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Footer text
                  Text(
                    'Please drink responsibly',
                    style: AppTextStyles.captionLight.copyWith(
                      color: AppColors.lightBeige.withOpacity(0.5),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
