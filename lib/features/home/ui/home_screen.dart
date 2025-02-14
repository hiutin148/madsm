import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:madsm/features/home/ui/view_model/bottom_nav_view_model.dart';
import 'package:madsm/features/new_feed/ui/new_feed_screen.dart';
import 'package:madsm/routing/routes.dart';

import '../../../features/profile/ui/profile_screen.dart';

const List<Widget> _screens = [
  NewFeedScreen(),
  ProfileScreen(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.push(Routes.createPost);
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Consumer(builder: (context, ref, __) {
        final currentIndex = ref.watch(bottomNavViewModelProvider).value ?? 0;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black45, blurRadius: 5.0),
            ],
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'menu_hero'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'menu_profile'.tr(),
              ),
            ],
            elevation: 12,
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(bottomNavViewModelProvider.notifier).switchTab(index);
              pageController.animateToPage(
                index,
                duration: Duration(
                  milliseconds: 100,
                ),
                curve: Curves.easeIn,
              );
            },
          ),
        );
      }),
    );
  }
}
