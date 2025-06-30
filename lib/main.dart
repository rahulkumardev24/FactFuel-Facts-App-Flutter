import 'package:fact_fuel/screens/starting/login_screen.dart';
import 'package:fact_fuel/screens/starting/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'helper/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// Show in full screen --- ///
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /// always portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  final prefs = await SharedPreferences.getInstance();

  /// Track first launch and launch count
  if (!prefs.containsKey('first_launch_date')) {
    prefs.setString('first_launch_date', DateTime.now().toIso8601String());
  }
  prefs.setInt('launch_count', (prefs.getInt('launch_count') ?? 0) + 1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'FactFuel',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
