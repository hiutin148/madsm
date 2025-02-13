import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

@riverpod
PostRepository postRepository(Ref ref) {
  return PostRepository();
}

class PostRepository {
  const PostRepository();

  Future<List<Post>> fetchPost() {
    return supabase.from('posts').select().then((response) => response.map((data) => Post.fromJson(data)).toList());
  }

  Future<void> publishPost(Post post) async {
    return supabase.from('posts').insert(post.toJson());
  }
}
