import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/common/ui/widgets/custom_snack_bar.dart';
import '../theme/app_colors.dart';

extension ThemeModeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get primaryBackgroundColor => isDarkMode ? AppColors.mono100 : AppColors.mono0;

  Color get secondaryBackgroundColor => isDarkMode ? AppColors.mono100 : AppColors.mono20;

  Color get secondaryWidgetColor => isDarkMode ? AppColors.mono90 : AppColors.mono0;

  Color get primaryTextColor => isDarkMode ? AppColors.mono20 : AppColors.mono100;

  Color get secondaryTextColor => isDarkMode ? AppColors.mono40 : AppColors.mono80;

  Color get dividerColor => isDarkMode ? AppColors.mono80 : AppColors.mono20;

  ThemeData get lightTheme => ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFF2C3930)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      )));

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFF2C3930)),
      );

  void showSuccessSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(CustomSnackBar.success(text: text));
  }

  void showInfoSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(CustomSnackBar.info(text: text));
  }

  void showWarningSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(CustomSnackBar.warning(text: text));
  }

  void showErrorSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(CustomSnackBar.error(text: text));
  }

  void tryLaunchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (mounted) {
        showErrorSnackBar('Can not open url: $url');
      }
    }
  }
}
