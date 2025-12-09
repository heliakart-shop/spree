import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/launcher_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: Could not load .env file: $e');
    print('Make sure to create .env file with your Claude API key');
  }

  runApp(const SpreePartyApp());
}

class SpreePartyApp extends StatelessWidget {
  const SpreePartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Spree Party',
      theme: AppTheme.theme,
      home: const LauncherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}