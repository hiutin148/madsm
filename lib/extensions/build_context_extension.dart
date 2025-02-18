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
          ),
        ),
        textTheme: TextTheme(
          // Display
          displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, height: 64 / 57, color: Colors.black),
          displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, height: 52 / 45, color: Colors.black),
          displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, height: 44 / 36, color: Colors.black),
          // Headline
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, height: 40 / 32, color: Colors.black),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, height: 36 / 28, color: Colors.black),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, height: 32 / 24, color: Colors.black),
          // Title
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, height: 28 / 22, color: Colors.black),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, color: Colors.black),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: Colors.black),
          // Body
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: Colors.black),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, color: Colors.black),
          // Label
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: Colors.black),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 16 / 12, color: Colors.black),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, height: 16 / 11, color: Colors.black),
        ),
      );

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

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);
}
