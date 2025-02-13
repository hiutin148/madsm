import 'dart:io';

import 'package:madsm/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageHelper {
  static final SupabaseStorageHelper instance = SupabaseStorageHelper._init();

  SupabaseStorageHelper._init();

  Future<String> uploadFile(String bucket, String path, File file) async {
    await supabase.storage.from(bucket).upload(
          path,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    final String publicUrl = supabase
        .storage
        .from(bucket)
        .getPublicUrl(path);
    return publicUrl;
  }

  void deleteFile(String bucket, String path) async {
    await supabase
        .storage
        .from(bucket)
        .remove([path]);
  }
}
