import 'package:flutter/material.dart';
import 'package:madsm/features/common/ui/widgets/material_ink_well.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 20,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: MaterialInkWell(onTap: onPressed, child: icon,));
  }
}
