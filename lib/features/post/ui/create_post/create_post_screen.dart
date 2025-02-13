import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/extensions/build_context_extension.dart';
import 'package:madsm/features/common/ui/widgets/circle_button.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/features/common/ui/widgets/common_icon_button.dart';
import 'package:madsm/features/common/ui/widgets/primary_button.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/features/post/ui/create_post/view_models/create_post_view_model.dart';
import 'package:madsm/features/profile/model/profile.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:madsm/theme/app_colors.dart';
import 'package:madsm/theme/app_theme.dart';
import 'package:madsm/utils/global_loading.dart';

import 'view_models/post_editor_view_model.dart';
import 'widgets/selected_media_item.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  bool isShowingButtons = false;

  @override
  void dispose() {
    if (ref.read(createPostViewModelProvider).value == false) {
      ref.read(postEditorViewModelProvider.notifier).discardPost();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      createPostViewModelProvider,
      (previous, next) {
        if (next.isLoading != previous?.isLoading) {
          if (next.isLoading) {
            Global.showLoading(context);
          } else {
            Global.hideLoading();
          }
        }

        if (next is AsyncError) {
          context.showErrorSnackBar(next.error.toString());
        }

        if (next is AsyncData) {
          if (next.value == true) {
            context.showSuccessSnackBar('Successfully publish');
          }
        }
      },
    );
    final medias = ref.watch(postEditorViewModelProvider).value?.media ?? [];
    final profile = ref.read(profileViewModelProvider).value?.profile;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              SizedBox(height: 36),
              buildTextInput(profile),
              SizedBox(height: 24),
              buildSelectedMedia(medias),
              SizedBox(height: 24),
              buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectedMedia(List<Media> medias) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        medias.length,
        (index) {
          return SelectedMediaItem(
            media: medias[index],
            onTap: () {},
            onDelete: () {
              ref.read(postEditorViewModelProvider.notifier).removeMedia(index);
            },
          );
        },
      ),
    );
  }

  Widget buildActionButton() {
    return Row(
      children: [
        CircleButton(
          size: 32,
          icon: Icon(!isShowingButtons ? Icons.add : Icons.close),
          onPressed: () {
            setState(() {
              isShowingButtons = !isShowingButtons;
            });
          },
          backgroundColor: Colors.white,
          borderWidth: 1,
        ),
        SizedBox(
          width: 12,
        ),
        AnimatedContainer(
          width: isShowingButtons ? 160 : 0,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(32),
          ),
          duration: Duration(
            milliseconds: 150,
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            scrollDirection: Axis.horizontal,
            children: [
              CommonIconButton(
                icon: SvgPicture.asset(Assets.icImage),
                onPressed: () async {
                  ref.read(postEditorViewModelProvider.notifier).pickMedia();
                  setState(() {
                    isShowingButtons = false;
                  });
                },
              ),
              SizedBox(width: 16),
              CommonIconButton(
                icon: SvgPicture.asset(Assets.icGIF),
                onPressed: () {
                  ref.read(postEditorViewModelProvider.notifier).pickGif(context);
                  setState(() {
                    isShowingButtons = false;
                  });
                },
              ),
              SizedBox(width: 16),
              CommonIconButton(
                icon: SvgPicture.asset(Assets.icCamera),
                onPressed: () {
                  ref.read(postEditorViewModelProvider.notifier).takePicture();
                  setState(() {
                    isShowingButtons = false;
                  });
                },
              ),
              SizedBox(width: 16),
              CommonIconButton(
                icon: SvgPicture.asset(Assets.icAttachment),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextInput(Profile? profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          child: CommonCachedImage(
            imageUrl: profile?.avatar ?? '',
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: TextField(
            onChanged: (value) {
              ref.read(postEditorViewModelProvider.notifier).changeText(value);
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What on your mind ?',
              hintStyle: AppTheme.bodyLarge16.copyWith(color: AppColors.lighterGrey),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Discard'),
          ),
          Text(
            "Create".toUpperCase(),
            style: AppTheme.titleExtraSmall14,
          ),
          SizedBox(
            width: 70,
            child: PrimaryButton(
              verticalPadding: 4,
              onPressed: () {
                ref.read(createPostViewModelProvider.notifier).publishPost();
              },
              text: 'Publish',
            ),
          ),
        ],
      ),
    );
  }
}
