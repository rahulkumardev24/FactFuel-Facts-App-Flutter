import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:fact_fuel/screens/home_screen.dart';
import 'package:fact_fuel/screens/categories_screen.dart';
import 'package:fact_fuel/screens/saved_screen.dart';
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

  /// screen
  final List<Widget> bottomBarPages = const [
    HomeScreen(),
    CategoriesScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      bottomNavigationBar:
          (bottomBarPages.length <= maxCount)
              ? AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: AppColors.secondary,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                kBottomRadius: 21.0,
                notchColor: AppColors.primary,
                removeMargins: false,
                bottomBarWidth: 500,
                durationInMilliSeconds: 300,
                itemLabelStyle: myTextStyle11(),
                elevation: 1,
                kIconSize: 24.0,
                showBlurBottomBar: true,

                bottomBarItems: [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    itemLabel: "Home",
                  ),

                  BottomBarItem(
                    inActiveItem: Icon(Icons.category, color: Colors.blueGrey),
                    activeItem: Icon(Icons.category, color:Colors.white),
                    itemLabel: "Categories",
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.bookmark_border,
                      color: Colors.blueGrey,
                    ),
                    activeItem: Icon(Icons.bookmark, color: Colors.white),

                    itemLabel: "Saved",
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
              )
              : null,
    );
  }
}
