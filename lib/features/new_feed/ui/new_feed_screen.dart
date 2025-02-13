import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/features/new_feed/ui/view_model/new_feed_view_model.dart';
import 'package:madsm/features/new_feed/ui/widgets/new_feed_item.dart';
import 'package:madsm/routing/routes.dart';
import 'package:madsm/theme/app_colors.dart';

import '../../../constants/languages.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/common_empty_data.dart';
import 'widgets/shimmer_hero_grid.dart';

class NewFeedScreen extends ConsumerWidget {
  const NewFeedScreen({super.key});

  String _getGreeting() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 5 && currentHour < 12) return Languages.goodMorning;
    if (currentHour >= 12 && currentHour < 18) return Languages.goodAfternoon;
    return Languages.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(newFeedViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(_getGreeting()),
          style: AppTheme.headLineLarge32,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: context.primaryBackgroundColor,
        foregroundColor: context.primaryTextColor,
      ),
      body: postsState.when(
        data: (state) {
          if (state.isEmpty) {
            return const CommonEmptyData();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.length,
            itemBuilder: (context, index) {
              final post = state[index];
              return NewFeedItem(post: post);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 24,
              );
            },
          );
        },
        loading: () => const ShimmerHeroGrid(),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.push(Routes.createPost);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
