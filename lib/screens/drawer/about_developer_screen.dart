import 'package:fact_fuel/helper/colors.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperScreen extends StatefulWidget {
  const AboutDeveloperScreen({super.key});

  @override
  State<AboutDeveloperScreen> createState() => _AboutDeveloperScreenState();
}

class _AboutDeveloperScreenState extends State<AboutDeveloperScreen> {
  /// Email function with proper encoding
  Future<void> _sendEmail(String email) async {
    final String subject = Uri.encodeComponent(
      'Hello Rahul - Contact via FactFuel App',
    );
    final String body = Uri.encodeComponent(
      'Dear Rahul,\n\n'
      'I came across your profile via the FactFuel app.\n\n'
      'I would like to connect with you regarding:\n'
      '- [Mention your reason: collaboration, hiring, project inquiry, etc.]\n\n'
      'Looking forward to your response.\n\n'
      'Best regards,\n'
      '[Your Name]',
    );

    final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showErrorSnackbar("No email app found to open.");
    }
  }

  /// LinkedIn profile launch
  Future<void> _launchLinkedIn() async {
    const profileUrl = 'https://www.linkedin.com/in/rahulkumardev24/';
    const fallbackUrl = 'https://www.linkedin.com/';

    if (await canLaunchUrl(Uri.parse(profileUrl))) {
      await launchUrl(
        Uri.parse(profileUrl),
        mode: LaunchMode.externalApplication,
      );
    } else if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
      await launchUrl(
        Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      _showErrorSnackbar("Could not open LinkedIn.");
    }
  }

  // GitHub profile launch
  Future<void> _launchGitHub() async {
    const profileUrl = 'https://github.com/rahulkumardev24';
    const fallbackUrl = 'https://github.com/';

    if (await canLaunchUrl(Uri.parse(profileUrl))) {
      await launchUrl(
        Uri.parse(profileUrl),
        mode: LaunchMode.externalApplication,
      );
    } else if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
      await launchUrl(
        Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      _showErrorSnackbar("Could not open GitHub.");
    }
  }

  // Portfolio website launch
  Future<void> _launchPortfolio() async {
    const portfolioUrl = 'https://rahulkumardev24.github.io';

    if (await canLaunchUrl(Uri.parse(portfolioUrl))) {
      await launchUrl(
        Uri.parse(portfolioUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      _showErrorSnackbar("Could not open portfolio website.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Developer', style: myTextStyle21()),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(height: size.height * 0.1),
                Expanded(
                  child: Container(
                    height: size.height,
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
            Positioned(
              top: size.height * 0.01,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                        width: size.width * 0.4,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: AppColors.background,
                          ),
                          image: const DecorationImage(
                            image: AssetImage(
                              "lib/assets/images/dev profile.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .animate()
                      .scale(duration: 400.ms)
                      .then()
                      .shake()
                      .animate()
                      .fadeIn(duration: 300.ms),
                  const SizedBox(height: 12),
                  Text(
                    'Rahul Kumar Sahu',
                    style: myTextStyle18(textColor: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 100,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ).animate().scaleX(delay: 200.ms),
                  const SizedBox(height: 6),
                  Text(
                    'Mobile App Developer ✦ FactFuel Creator',
                    style: myTextStyle16(textColor: AppColors.textSecondary),
                  ),
                  SizedBox(height: size.height * 0.10),
                  _buildConnectSection(context, size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectSection(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: Divider(color: AppColors.primary)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.primary),
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4,
                    ),
                    child: Text(
                      'Let\'s Connect',
                      style: myTextStyle16(
                        textColor: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().slideX(begin: 0.5, duration: 300.ms),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.primary)),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                [
                  _buildNeumorphicButton(
                    context: context,
                    icon: FontAwesomeIcons.envelope,
                    color: Colors.red,
                    title: "Email",
                    size: size,
                    onPress: () => _sendEmail("rkrahulroy151617@gmail.com"),
                  ),
                  _buildNeumorphicButton(
                    context: context,
                    icon: FontAwesomeIcons.linkedin,
                    color: Colors.blue,
                    title: "LinkedIn",
                    size: size,
                    onPress: _launchLinkedIn,
                  ),
                  _buildNeumorphicButton(
                    context: context,
                    icon: FontAwesomeIcons.github,
                    color: Colors.black,
                    title: "GitHub",
                    size: size,
                    onPress: _launchGitHub,
                  ),
                ].animate(interval: 100.ms).scale(),
          ),
          const SizedBox(height: 25),

          /// Portfolio Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primaryLight.withValues(alpha: 0.3),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _launchPortfolio,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.public, color: AppColors.textPrimary),
                      const SizedBox(width: 10),
                      Text(
                        'Explore My Portfolio',
                        style: myTextStyle16(textColor: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().slideY(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildNeumorphicButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPress,
    required Size size,
    required String title,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPress,
      child: Column(
        children: [
          Container(
            width: size.height * 0.06,
            height: size.height * 0.06,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.4),
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(title, style: myTextStyle14(textColor: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
