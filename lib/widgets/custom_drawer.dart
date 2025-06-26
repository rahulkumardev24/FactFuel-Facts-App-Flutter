import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/helper/fact_utils.dart';
import 'package:fact_fuel/screens/starting/login_screen.dart';
import 'package:fact_fuel/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helper/colors.dart';
import '../service/auth_service.dart';
import 'custom_drawer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    FactUtils.getCurrentUserData();
  }

  List<DrawerItem> _drawerItems(BuildContext context) {
    return [
      DrawerItem(icon: FontAwesomeIcons.bolt, title: "Trending", onTap: () {}),

      DrawerItem(
        icon: FontAwesomeIcons.shareFromSquare,
        title: "Share App",
        onTap: () {},
      ),

      DrawerItem(
        icon: FontAwesomeIcons.userAstronaut,
        title: "About Developer",
        onTap: () {},
      ),

      DrawerItem(
        icon: FontAwesomeIcons.comments,
        title: "Feedback",
        onTap: () {},
      ),

      DrawerItem(
        icon: FontAwesomeIcons.rightFromBracket,
        title: "Logout",
        onTap: () async {
          await AuthService().signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final drawerItems = _drawerItems(context);

    return Animate(
      effects: [
        SlideEffect(
          duration: 1000.ms,
          begin: const Offset(-1, 0),
          end: Offset.zero,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: Drawer(
        width: size.width * 0.6,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark.withValues(alpha: 0.9),
                AppColors.primary.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Column(
            children: [
              /// Header Section
              _buildHeader(size),

              /// Main Menu Items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,

                  itemCount: drawerItems.length,
                  itemBuilder: (context, index) {
                    return _buildDrawerItem(
                      item: drawerItems[index],
                      index: index,
                    );
                  },
                ),
              ),

              /// Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: FactUtils.getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final userData = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,

              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: MyIconButton(
                    icon: FontAwesomeIcons.xmark,
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: size.height * 0.3,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(userData['userProfile']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        userData['userName'],
                        style: myTextStyle18(
                          textColor: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        userData['email'],
                        style: myTextStyle12(textColor: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text("No Data Found"));
        }
      },
    );
  }

  Widget _buildDrawerItem({required DrawerItem item, required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        splashColor: AppColors.secondary.withValues(alpha: 0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: AppColors.iconSecondary),
              const SizedBox(width: 15),
              Text(
                item.title,
                style: myTextStyle14(textColor: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Drawer Footer
  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: Colors.white30, height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "FactFuel v1.0",
            style: myTextStyle12(textColor: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerItem({required this.icon, required this.title, required this.onTap});
}
