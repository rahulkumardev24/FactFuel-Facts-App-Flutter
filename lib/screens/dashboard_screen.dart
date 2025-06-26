import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fact_fuel/screens/home_screen.dart';
import 'package:fact_fuel/screens/categories_screen.dart';
import 'package:fact_fuel/screens/saved_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../helper/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  final int maxCount = 3;
  bool _isDrawerOpen = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// screen
    final List<Widget> bottomBarPages = [
      HomeScreen(
        onDrawerChanged: (isOpen) {
          setState(() {
            _isDrawerOpen = isOpen;
          });
        },
      ),
      CategoriesScreen(),
      SavedScreen(),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: bottomBarPages,
          ),
        ),
        bottomNavigationBar:
            (_isDrawerOpen || bottomBarPages.length > maxCount)
                ? null
                : Animate(
                  effects: [SlideEffect(duration: 700.ms, begin: Offset(0, 1))],
                  child: AnimatedNotchBottomBar(
                    notchBottomBarController: _controller,

                    /// bottom bar background
                    color: AppColors.primary,
                    showLabel: true,
                    textOverflow: TextOverflow.visible,
                    showBlurBottomBar: true,
                    maxLine: 1,
                    kBottomRadius: 21.0,
                    notchColor: AppColors.primary,
                    removeMargins: false,
                    showBottomRadius: true,
                    showShadow: false,
                    showTopRadius: true,
                    blurOpacity: 0.2,
                    durationInMilliSeconds: 300,
                    itemLabelStyle: myTextStyle11(
                      textColor: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 0,
                    kIconSize: 24.0,
                    shadowElevation: 0,
                    bottomBarWidth: size.width,
                    bottomBarHeight:
                        size.height >= 600
                            ? size.height * 0.08
                            : size.height * 0.05,

                    bottomBarItems: [
                      /// home
                      BottomBarItem(
                        inActiveItem: Icon(
                          CupertinoIcons.house_alt,
                          color: AppColors.iconSecondary,
                        ),
                        activeItem: Icon(
                          CupertinoIcons.house_alt_fill,
                          color: AppColors.iconPrimary,
                        ),
                        itemLabel: "Home",
                      ),

                      /// categories
                      BottomBarItem(
                        inActiveItem: Icon(
                          CupertinoIcons.rectangle_on_rectangle_angled,
                          color: AppColors.iconSecondary,
                        ),
                        activeItem: Icon(
                          CupertinoIcons
                              .rectangle_fill_on_rectangle_angled_fill,
                          color: AppColors.iconPrimary,
                        ),
                        itemLabel: "Categories",
                      ),

                      /// saved
                      BottomBarItem(
                        inActiveItem: Icon(
                          CupertinoIcons.heart,
                          color: AppColors.iconSecondary,
                        ),
                        activeItem: Icon(
                          CupertinoIcons.heart_fill,
                          color: AppColors.iconPrimary,
                        ),

                        itemLabel: "Saved",
                      ),
                    ],
                    onTap: (index) {
                      _pageController.jumpToPage(index);
                    },
                  ),
                ),
      ),
    );
  }
}
