import 'package:fact_fuel/screens/categories_screen.dart';
import 'package:fact_fuel/screens/login_screen.dart';
import 'package:fact_fuel/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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

  /// ✅ Change status bar color here
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FactFuel',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
