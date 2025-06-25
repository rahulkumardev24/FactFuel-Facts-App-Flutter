import 'package:flutter/material.dart';
import '../helper/colors.dart'; // Your custom colors

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const NavigationButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: AppColors.iconSecondary , size: 24,),
        ),
      ),
    );
  }
}
