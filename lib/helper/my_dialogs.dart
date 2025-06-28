import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'colors.dart';
import 'custom_text_style.dart';

class _DialogUtils {
  static Future<void> _showThankYouDialog(BuildContext context, Size mqData) async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: mqData.width * 0.85,
              height: mqData.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      alignment: Alignment.center,
                      "assets/animations/thank you.json",
                      height: mqData.width * 0.6,
                      fit: BoxFit.fill,
                      repeat: true,
                    ),
                  ),
                  Text(
                    "Thank You for Sharing!",
                    style: myTextStyle18(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Your support helps us grow and improve the app for everyone!",
                      textAlign: TextAlign.center,
                      style: myTextStyle14(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Continue",
                      style: myTextStyle18(
                        fontWeight: FontWeight.bold,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: mqData.height * 0.01),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyDialogs {
  static void showCustomSnackBar(
    BuildContext context, {
    String? title,
    Color backGround = Colors.black38,
    Color fontColor = Colors.white70,
  }) {
    if (title != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backGround,
          content: Text(title, style: myTextStyle18(textColor: fontColor)),
        ),
      );
    }
  }

  static Future<void> shareApp(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final mqData = MediaQuery.of(context).size;
    const String playStoreLink = "https://drive.google.com/file/d/your_apk_file_id/view?usp=sharing";
    const String shareText = '🔥 Discover mind-blowing facts daily with the *FactFuel* app! Download now :\n$playStoreLink';

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'FactFuel - Your Daily Dose of Knowledge',
        ),
      );

      if (!context.mounted) return;
      
      if (result.status == ShareResultStatus.success) {
        // Show impressive thank you animation in a separate function
        await _DialogUtils._showThankYouDialog(context, mqData);
      }
    } catch (e) {
      debugPrint('Sharing failed: \$e');
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text("Failed to share")),
        );
      }
    }
  }

  static void myShowSnackBar(
    BuildContext context,
    String title,
    Color backgroundColor,
    Color textColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title, style: myTextStyle18(textColor: textColor)),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Circular progressbar
  static void myShowProgressbar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static Widget myCircularProgressIndicator(Size size){
   return  Stack(
      alignment: Alignment.center,
      children: [
        // Background track
        SizedBox(
          height: size.width * 0.2,
          width: size.width * 0.2,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation(Colors.grey[300]),
          ),
        ),

        /// ---- Animated progress ----- ////
        TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 0.95),
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          builder: (context, value, _) {
            return SizedBox(
              height: size.width * 0.2,
              width: size.width * 0.2,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 5,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation(
                  ColorTween(
                    begin: AppColors.primaryLight,
                    end: AppColors.primary,
                  ).lerp(value)!,
                ),
              ),
            );
          },
        ),


      ],
    );
  }

}
