import 'dart:io';

import 'package:client/core/utils/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePicker extends ChangeNotifier implements FilePickerInterface {
  @override
  Future<File?> pickFile() async {
    try {
      final filePickerRes =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (filePickerRes != null) {
        return File(filePickerRes.files.first.xFile.path);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
