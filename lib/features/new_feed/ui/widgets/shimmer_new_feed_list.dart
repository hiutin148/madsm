import 'package:flutter/material.dart';
import 'package:madsm/constants/dimens.dart';
import 'package:madsm/features/common/ui/widgets/shimmer_post_item.dart';

import '../../../common/ui/widgets/common_shimmer.dart';

class ShimmerNewFeedList extends StatelessWidget {
  const ShimmerNewFeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return const ShimmerPostItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: Dimens.padding);
      },
    );
  }
}

class ShimmerHeroItem extends StatelessWidget {
  const ShimmerHeroItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CommonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 4,
              child: ColoredBox(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
