import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/features/post/model/comment/comment.dart';
import 'package:madsm/features/post/model/post/post.dart';
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

  Future<Post> getPostById(String postId) async {
    final result = await supabase.from('posts').select().eq('id', postId).single();
    return Post.fromJson(result);
  }

  Future<void> publishPost(Post post) async {
    return supabase.from('posts').insert(post.toJson());
  }

  Future<Post> likePost({
    required String postId,
    required String userId,
  }) async {
    // Tăng like_count bằng RPC
    await supabase.rpc('increment', params: {
      'table_name': 'posts',
      'column_name': 'like_count',
      'row_id': postId,
    });

    // Thêm userId vào danh sách liked_by bằng RPC
    await supabase.rpc('append_to_array', params: {
      'table_name': 'posts',
      'column_name': 'liked_by',
      'value': userId,
      'row_id': postId,
    });

    // Lấy post đã cập nhật
    final result = await supabase.from('posts').select().eq('id', postId).single();

    return Post.fromJson(result);
  }

  Future<Post> unlikePost({
    required String postId,
    required String userId,
  }) async {
    // Tăng like_count bằng RPC
    await supabase.rpc('decrease', params: {
      'table_name': 'posts',
      'column_name': 'like_count',
      'row_id': postId,
    });

    // Thêm userId vào danh sách liked_by bằng RPC
    await supabase.rpc('remove_from_array', params: {
      'table_name': 'posts',
      'column_name': 'liked_by',
      'value': userId,
      'row_id': postId,
    });

    // Lấy post đã cập nhật
    final result = await supabase.from('posts').select().eq('id', postId).single();

    return Post.fromJson(result);
  }

  Future<List<Comment>> getPostComments(String postId) async {
    final result = await supabase.from('comments').select().eq('post_id', postId).order('created_at', ascending: false);
    return result.map((data) => Comment.fromJson(data)).toList();
  }

  Future<void> sendComment(Comment comment) async {
    await supabase.rpc('increment', params: {
      'table_name': 'posts',
      'column_name': 'comment_count',
      'row_id': comment.postId,
    });
    return supabase.from('comments').insert(comment.toJson());
  }

  Future<Comment> likeComment({
    required String commentId,
    required String userId,
  }) async {
    // Tăng like_count bằng RPC
    await supabase.rpc('increment', params: {
      'table_name': 'comments',
      'column_name': 'like_count',
      'row_id': commentId,
    });

    // Thêm userId vào danh sách liked_by bằng RPC
    await supabase.rpc('append_to_array', params: {
      'table_name': 'comments',
      'column_name': 'liked_by',
      'value': userId,
      'row_id': commentId,
    });

    // Lấy post đã cập nhật
    final result = await supabase.from('comments').select().eq('id', commentId).single();

    return Comment.fromJson(result);
  }

  Future<Comment> unlikeComment({
    required String commentId,
    required String userId,
  }) async {
    // Tăng like_count bằng RPC
    await supabase.rpc('decrease', params: {
      'table_name': 'comments',
      'column_name': 'like_count',
      'row_id': commentId,
    });

    // Thêm userId vào danh sách liked_by bằng RPC
    await supabase.rpc('remove_from_array', params: {
      'table_name': 'comments',
      'column_name': 'liked_by',
      'value': userId,
      'row_id': commentId,
    });

    // Lấy post đã cập nhật
    final result = await supabase.from('comments').select().eq('id', commentId).single();

    return Comment.fromJson(result);
  }
}
