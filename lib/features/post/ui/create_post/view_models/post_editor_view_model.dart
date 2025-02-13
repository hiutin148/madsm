import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsm/constants/constants.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/features/post/ui/create_post/state/post_editor_state.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:madsm/utils/supabase_storage_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_editor_view_model.g.dart';

@riverpod
class PostEditorViewModel extends _$PostEditorViewModel {
  @override
  FutureOr<PostEditorState> build() async {
    return PostEditorState();
  }

  void changeText(String text) {
    state = AsyncData(state.value!.copyWith(content: text));
  }

  void pickMedia() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickMedia();
      if (image == null) {
        return;
      }
      final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? 'Unknown_user';
      final path = '$userId/images/${DateTime.now().millisecondsSinceEpoch}';
      final url = await SupabaseStorageHelper.instance.uploadFile(Constants.userMediaBucket, path, File(image.path));
      state = AsyncData(
        state.value!.copyWith(
          media: [
            ...state.value!.media,
            Media(
              url: url,
              path: path,
              type: MediaType.image,
            )
          ],
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void takePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      }
      final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? 'Unknown_user';
      final path = '$userId/images/${DateTime.now().millisecondsSinceEpoch}';
      final url = await SupabaseStorageHelper.instance.uploadFile(Constants.userMediaBucket, path, File(image.path));
      state = AsyncData(
        state.value!.copyWith(
          media: [
            ...state.value!.media,
            Media(
              url: url,
              path: path,
              type: MediaType.image,
            )
          ],
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void pickGif(BuildContext context) async {
    final gif = await GiphyPicker.pickGif(
      showPreviewPage: false,
      context: context,
      apiKey: 'BMWoyAlf9g20p65SSpjkGruNQBQGZzT1',
    );
    if (gif == null) {
      return;
    }
    state = AsyncData(
      state.value!.copyWith(
        media: [
          ...state.value!.media,
          Media(
            url: gif.images.original?.url ?? '',
            type: MediaType.gif,
          )
        ],
      ),
    );
  }

  void removeMedia(int index) {
    try {
      List<Media> temp = state.value?.media ?? [];
      SupabaseStorageHelper.instance.deleteFile(Constants.userMediaBucket, temp[index].path ?? '');
      temp.removeAt(index);
      state = AsyncData(
        state.value!.copyWith(
          media: temp,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void discardPost() {
    try {
      for (Media media in state.value?.media ?? []) {
        SupabaseStorageHelper.instance.deleteFile(Constants.userMediaBucket, media.path ?? '');
      }
      state = AsyncData(PostEditorState());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
