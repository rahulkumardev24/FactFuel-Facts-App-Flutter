import 'package:flutter/material.dart';

import '../helper/colors.dart';


class MyIconButton extends StatelessWidget {
  IconData icon;
  Color? iconColor;
  double iconSize;
  VoidCallback onTap;
  MyIconButton({
    super.key,
    required this.icon,
    this.iconColor = AppColors.iconDark,
    this.iconSize = 20.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}
