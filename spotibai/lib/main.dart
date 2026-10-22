import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/library_provider.dart';
import 'providers/player_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

/// App entry point.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Light icons on a transparent status bar to match the dark theme.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);

  runApp(const SpotiBaiApp());
}

/// Root widget: registers the global providers and the dark theme.
class SpotiBaiApp extends StatelessWidget {
  const SpotiBaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Liked songs, saved library items, downloads.
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        // Queue, play/pause, shuffle/repeat and the fake progress timer.
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: MaterialApp(
        title: 'SpotiBai',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
