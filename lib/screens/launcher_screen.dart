import 'package:flutter/material.dart';
import 'package:spree_party/screens/splash_screen.dart';
import '../services/app_initializer.dart';
import '../widgets/loading_screen.dart';
import '../widgets/content_screen.dart';
import '../widgets/network_error_dialog.dart';
import '../utils/app_config.dart';
import 'main_menu_screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> with TickerProviderStateMixin {
  AppState _currentState = AppState.initializing;
  String? _resourcePath;
  String? _initialURL;
  bool _hasNavigatedAway = false;
  double _progress = 0.0;

  late AnimationController _rotationController;
  AppInitializer? _initializer;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startInitialization();
  }

  void _setupAnimation() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationController.repeat();
  }

  void _startInitialization() {
    _initializer = AppInitializer(
      onComplete: _handleInitializationComplete,
      onError: _handleInitializationError,
      onShowMainMenu: _handleShowMainMenu,
      onProgressUpdate: _handleProgressUpdate,
    );

    _initializer!.initialize();
  }

  void _handleInitializationComplete() {
    setState(() {
      _currentState = AppState.contentView;
      _resourcePath = AppConfig.defaultEndpoint;
      _initialURL = AppConfig.defaultEndpoint;
    });
  }

  void _handleInitializationError() {
    setState(() {
      _currentState = AppState.error;
    });
  }

  void _handleShowMainMenu() {
    setState(() {
      _currentState = AppState.mainMenu;
    });
  }

  void _handleProgressUpdate(double progress) {
    setState(() {
      _progress = progress;
    });
  }

  void _handleNavigationChanged(String url) {
    if (_initialURL != null &&
        !url.toLowerCase().contains(_initialURL!.toLowerCase())) {
      setState(() {
        _hasNavigatedAway = true;
      });
    }
  }

  void _handleContentViewClose() {
    setState(() {
      _currentState = AppState.mainMenu;
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _initializer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case AppState.initializing:
        return LoadingScreen(
          rotationController: _rotationController,
          progress: _progress,
        );

      case AppState.contentView:
        return ContentScreen(
          resourcePath: _resourcePath ?? AppConfig.defaultEndpoint,
          initialURL: _initialURL,
          hasNavigatedAwayFromInitial: _hasNavigatedAway,
          onClose: _handleContentViewClose,
          onNavigationChanged: _handleNavigationChanged,
        );

      case AppState.error:
        return const NetworkErrorDialog();

      case AppState.mainMenu:
        return const SplashScreen();
    }
  }
}

enum AppState {
  initializing,
  contentView,
  error,
  mainMenu,
}
