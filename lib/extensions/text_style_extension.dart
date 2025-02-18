import 'package:flutter/material.dart';
import 'package:madsm/theme/app_colors.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get lighterGrey => copyWith(color: AppColors.lighterGrey);
}
