import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @Default(null) String? id,
    @Default(null) String? email,
    @Default(null) String? username,
    @Default(null) String? job,
    @JsonKey(name: 'avatar_url')
    @Default(null) String? avatar,
    @Default(null) int? diamond,
    @JsonKey(name: 'expiry_date_premium')
    @Default(null)
    DateTime? expiryDatePremium,
    @JsonKey(name: 'is_lifetime_premium')
    @Default(null)
    bool? isLifetimePremium,
    @Default([]) List<String> followings,
    @Default([]) List<String> followers,
    @JsonKey(name: 'fcm_token')
    String? fcmToken,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
