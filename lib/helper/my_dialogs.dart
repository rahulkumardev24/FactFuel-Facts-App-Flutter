import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'colors.dart';
import 'custom_text_style.dart';

class _DialogUtils {
  static Future<void> _showThankYouDialog(
    BuildContext context,
    Size mqData,
  ) async {
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
    const String playStoreLink =
        "https://drive.google.com/file/d/your_apk_file_id/view?usp=sharing";
    const String shareText =
        '🔥 Discover mind-blowing facts daily with the *FactFuel* app! Download now :\n$playStoreLink';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
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

  static Widget myCircularProgressIndicator() {
    return SizedBox(
      child: CircularProgressIndicator(
        strokeWidth: 8,
        color: AppColors.primaryLight,
      ),
    );
  }
}
