import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/features/new_feed/ui/view_model/new_feed_view_model.dart';
import 'package:madsm/features/new_feed/ui/widgets/new_feed_item.dart';

import '../../../constants/languages.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/common_empty_data.dart';
import 'widgets/shimmer_new_feed_list.dart';

class NewFeedScreen extends ConsumerStatefulWidget {
  const NewFeedScreen({super.key});

  @override
  ConsumerState<NewFeedScreen> createState() => _NewFeedScreenState();
}

class _NewFeedScreenState extends ConsumerState<NewFeedScreen> with AutomaticKeepAliveClientMixin {
  String _getGreeting() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 5 && currentHour < 12) return Languages.goodMorning;
    if (currentHour >= 12 && currentHour < 18) return Languages.goodAfternoon;
    return Languages.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(newFeedViewModelProvider.notifier).refreshNewFeed();
        },
        child: CustomScrollView(
          slivers: [
            postsState.when(
              data: (state) {
                if (state.isEmpty) {
                  return SliverToBoxAdapter(child: const CommonEmptyData());
                }
                return SliverList.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    final post = state[index];
                    return NewFeedItem(post: post);
                  },
                  addAutomaticKeepAlives: false,
                );
              },
              loading: () => SliverToBoxAdapter(child: const ShimmerNewFeedList()),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
