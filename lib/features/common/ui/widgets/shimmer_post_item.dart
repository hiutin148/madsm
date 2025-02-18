import 'package:flutter/material.dart';
import 'package:madsm/constants/dimens.dart';
import 'package:madsm/features/common/ui/widgets/common_shimmer.dart';
import 'package:madsm/theme/app_colors.dart';

class ShimmerPostItem extends StatelessWidget {
  const ShimmerPostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.lighterGrey.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding,
              vertical: 16,
            ),
            child: CommonShimmer(
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxWidth * 0.75,
                        child: Container(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
