import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }
}
