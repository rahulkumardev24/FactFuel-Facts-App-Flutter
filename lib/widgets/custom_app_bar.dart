import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/widgets/navigation_button.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onIconPressed;
  final Color backgroundColor;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.icon,
    required this.onIconPressed,
    this.backgroundColor = AppColors.primary,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          SizedBox(width: size.width * 0.03),

          /// Call Navigation button
          NavigationButton(icon: icon, onPressed: onIconPressed),
          SizedBox(width: size.width * 0.05),
          Text(
            title,
            style: myTextStyle21(
              fontWeight: FontWeight.bold,
              textColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
