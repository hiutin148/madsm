import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:madsm/features/new_feed/ui/new_feed_screen.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../features/profile/ui/profile_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';

const List<Widget> _screens = [
  NewFeedScreen(),
  ProfileScreen(),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        context.isDarkMode ? AppColors.blueberry100 : AppColors.blueberry100;
    final unselectedColor =
        context.isDarkMode ? AppColors.mono40 : AppColors.mono60;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedZap,
              color: _currentIndex == 0 ? selectedColor : unselectedColor,
              size: 20,
            ),
            label: 'menu_hero'.tr(),
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: _currentIndex == 1 ? selectedColor : unselectedColor,
              size: 20,
            ),
            label: 'menu_profile'.tr(),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: context.secondaryWidgetColor,
        selectedItemColor: selectedColor,
        selectedLabelStyle: AppTheme.titleTiny12,
        unselectedLabelStyle: AppTheme.titleTiny12,
      ),
    );
  }
}
