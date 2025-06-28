import 'package:flutter/material.dart';

import '../helper/colors.dart';


@immutable
class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final VoidCallback onTap;
  
  const MyIconButton({
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
