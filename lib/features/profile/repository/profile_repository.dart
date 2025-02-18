
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/profile/model/profile.dart';
import '../../../main.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository();
}

class ProfileRepository {
  const ProfileRepository();

  Future<Profile?> get() async {
    final userId = supabase.auth.currentUser?.id ?? '';
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    final result = Profile.fromJson(data);
    return result;
  }

  Future<void> update(Profile profile) async {
    try {
      await supabase
          .from('profiles')
          .update({
            if (profile.email != null) 'email': profile.email,
            if (profile.username != null) 'username': profile.username,
            if (profile.job != null) 'job': profile.job,
            if (profile.avatar != null) 'avatar_url': profile.avatar,
            if (profile.diamond != null) 'diamond': profile.diamond,
            if (profile.fcmToken != null) 'fcm_token': profile.fcmToken,
            if (profile.expiryDatePremium != null)
              'expiry_date_premium':
                  profile.expiryDatePremium?.toIso8601String(),
            if (profile.isLifetimePremium != null)
              'is_lifetime_premium': profile.isLifetimePremium,
          })
          .eq('id', profile.id ?? '')
          .select();
    } catch (e) {
      rethrow;
    }
  }
}
