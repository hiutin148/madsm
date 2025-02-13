import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class CircleButton extends StatelessWidget {
  final Widget icon;
  final Function()? onPressed;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final bool isEnable;
  final Color borderColor;
  final double borderWidth;

  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 64,
    this.iconColor = AppColors.mono100,
    this.backgroundColor = AppColors.mono20,
    this.isEnable = true,
    this.borderColor = AppColors.gradient100,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isEnable ? backgroundColor : AppColors.mono40,
        shape: BoxShape.circle,
        border: borderWidth != 0 ? Border.all(
          color: borderColor,
          width: borderWidth,
        ) : null,
      ),
      child: Center(
        child: IconButton(
          iconSize: size / 2,
          padding: EdgeInsets.zero,
          color: isEnable ? iconColor : AppColors.mono80,
          onPressed: isEnable ? onPressed : null,
          icon: icon,
        ),
      ),
    );
  }
}
