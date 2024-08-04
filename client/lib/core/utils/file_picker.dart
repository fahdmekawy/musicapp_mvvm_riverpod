import 'dart:io';

abstract interface class FilePickerInterface {
  Future<File?> pickFile();
}
