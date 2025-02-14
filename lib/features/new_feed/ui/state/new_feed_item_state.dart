import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:madsm/features/post/model/post.dart';

part 'new_feed_item_state.freezed.dart';

@freezed
class NewFeedItemState with _$NewFeedItemState {
  factory NewFeedItemState({
    required Post post,
    required bool isLiked,
  }) = _NewFeedItemState;
}
