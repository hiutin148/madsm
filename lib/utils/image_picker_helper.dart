import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerHelper {
  static Future<File?> pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) return null;
    return compressImage(File(pickedFile.path));
  }

  static Future<File?> compressImage(File file) async {
    String tempPath = getCompressedPath(file.path);

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempPath,
      quality: 75,
      format: CompressFormat.png,
    );

    if (result == null) {
      return null;
    }
    await file.delete();
    return File(result.path).rename(file.path);
  }

  static String getCompressedPath(String filePath) {
    // Lấy phần mở rộng (vd: ".jpg")
    String extension = filePath.substring(filePath.lastIndexOf("."));

    // Lấy phần tên file không có extension (vd: "a")
    String fileNameWithoutExt = filePath.substring(0, filePath.lastIndexOf("."));

    // Tạo đường dẫn mới với "_compressed" trước extension
    return "${fileNameWithoutExt}_compressed.png";
  }
}
