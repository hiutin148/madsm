import 'package:image_picker/image_picker.dart';
import 'package:madsm/constants/constants.dart';
import 'package:madsm/utils/image_picker_helper.dart';
import 'package:madsm/utils/supabase_storage_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/profile/model/profile.dart';
import '../../../../features/profile/repository/profile_repository.dart';
import '../../../../features/profile/ui/state/profile_state.dart';
import '../../../authentication/ui/view_models/authentication_view_model.dart';

part 'profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel {
  @override
  FutureOr<ProfileState> build() async {
    final profile = await ref.read(profileRepositoryProvider).get();
    return ProfileState(profile: profile);
  }

  Future<void> updateProfile({
    String? email,
    String? name,
    String? avatar,
  }) async {
    state = const AsyncValue.loading();
    try {
      final currentProfile = state.value?.profile;

      final updatedProfile = currentProfile?.copyWith(
            email: email ?? currentProfile.email,
            name: name ?? currentProfile.name,
            avatar: avatar ?? currentProfile.avatar,
          ) ??
          Profile(
            email: email,
            name: name,
            avatar: avatar,
          );

      await ref.read(profileRepositoryProvider).update(updatedProfile);
      state = AsyncData(ProfileState(profile: updatedProfile));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void updateAvatar(ImageSource imageSource) async {
    final image = await ImagePickerHelper.pickImage(imageSource);
    if (image != null) {
      final userId = state.value?.profile?.id ?? 'Unknown_user';
      final path = '$userId/images/${DateTime.now().millisecondsSinceEpoch}';
      final url = await SupabaseStorageHelper.instance.uploadFile(
        Constants.avatarsBucket,
        path,
        image,
      );
      updateProfile(avatar: url);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await ref.read(profileRepositoryProvider).get();
      state = AsyncData(ProfileState(profile: profile));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authenticationViewModelProvider.notifier).signOut();
      state = AsyncData(ProfileState(profile: null));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
