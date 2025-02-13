import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

@freezed
class CreatePostState with _$CreatePostState {
  const factory CreatePostState.initial() = _Initial;
  const factory CreatePostState.loading() = _Loading;
  const factory CreatePostState.success() = _Success;
  const factory CreatePostState.failure(String error) = _Failure;
}
