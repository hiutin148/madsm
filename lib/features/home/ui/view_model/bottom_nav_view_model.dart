import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav_view_model.g.dart';

@riverpod
class BottomNavViewModel extends _$BottomNavViewModel {
  @override
  FutureOr<int> build() async {
    return 0;
  }

  void switchTab(int index) {
    state = AsyncData(index);
  }
}
