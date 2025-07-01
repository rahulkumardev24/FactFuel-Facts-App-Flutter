import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/helper/my_dialogs.dart';
import 'package:fact_fuel/screens/dashboard_screen.dart';
import 'package:fact_fuel/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../helper/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _animationController;


  final List<String> facts = [
    "Octopuses have three hearts and blue blood.",
    'Hot water freezes faster than cold water.',
    "Human teeth are as strong as shark teeth, but not as sharp.",
    'The tongue is the strongest muscle in the body relative to its size.',
    "Wearing headphones for just one hour can increase bacteria in your ears by 700%.",
    'Your stomach acid is strong enough to dissolve razor blades.',
  ];

  int _currentFactIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loginWithGoogle() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (user != null) {
        // Store navigation in a variable to avoid using context after async gap
        final navigator = Navigator.of(context);
        navigator.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const DashboardScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else {
        MyDialogs.myShowSnackBar(
          context,
          "Login failed. Please try again.",
          Colors.red,
          AppColors.textPrimary,
        );
      }
    } catch (e) {
      if (mounted) {
        MyDialogs.myShowSnackBar(
          context,
          "An error occurred: ${e.toString()}",
          Colors.red,
          AppColors.textPrimary,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 1),
            Hero(
              tag: 'app-logo',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "Fact Fuel",
                  style: myTextStyle26(
                    fontWeight: FontWeight.bold,
                    textColor: AppColors.primaryLight,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Fuel your curiosity with amazing facts",
              style: myTextStyle16(textColor: AppColors.primary),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height * 0.05),

            /// Facts carousel
            SizedBox(
              height: size.height * 0.4,
              width: size.width * 0.8,
              child: CardSwiper(
                cardsCount: facts.length,
                cardBuilder: (context, index, _, __) {
                  return _buildFactCard(size, facts[index]);
                },
                onSwipe: (previousIndex, currentIndex, direction) {
                  setState(() => _currentFactIndex = currentIndex ?? 0);
                  return true;
                },
                padding: EdgeInsets.all(16),
                scale: 0.9,
                isLoop: true,
              ),
            ),

            SizedBox(height: 8),

            /// Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                facts.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentFactIndex == index
                              ? Colors.yellow
                              : Colors.yellow.withAlpha(128), // 50% opacity
                    ),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),

            /// Google sign in button
            Column(
              children: [
                Text(
                  "Get Started in Seconds",
                  style: myTextStyle16(
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 12),

                _isLoading
                    ? Center(child: MyDialogs.myCircularProgressIndicator())
                    : SizedBox(
                      width: size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : loginWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'lib/assets/images/google_image.png',
                              height: size.height * 0.02,
                              width: size.height * 0.02,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Continue with Google",
                              style: myTextStyle18(
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),

            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildFactCard(Size size, String fact) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Image.asset(
              "lib/assets/icons/fact.png",
              height: size.height * 0.08,
              width: size.height * 0.08,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              fact,
              textAlign: TextAlign.center,
              style: myTextStyle18(
                fontWeight: FontWeight.w600,
                textColor: AppColors.textPrimary,
              ),
            ),
            Spacer(),
            Text(
              "Did you know?",
              style: TextStyle(
                color: AppColors.textDark.withValues(alpha: 0.5),
                fontFamily: "primary",
                fontStyle: FontStyle.italic,
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
