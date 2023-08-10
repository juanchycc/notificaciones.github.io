import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class FileHelper extends ChangeNotifier {
  // last load items
  PlatformFile? imageFile;
  PlatformFile? otherFile;

  //all load items
  Map<String, List<int>> images = {};
  Map<String, List<int>> files = {};

  PlatformFile? getLastImage() => imageFile;
  PlatformFile? getLastFile() => otherFile;
  Map<String, List<int>> getImages() => images;
  Map<String, List<int>> getFiles() => files;

  Future<bool> pickImage(BuildContext context) async {
    try {
      FilePickerResult? result;

      // Pick an image file using file_picker package
      if (kIsWeb) {
        result = await FilePickerWeb.platform.pickFiles(
          type: FileType.image,
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
      }

      // If user cancels the picker, do nothing
      if (result == null) return false;

      imageFile = result.files.first;
      images[imageFile!.name] = imageFile!.bytes!;

      notifyListeners();
      return true;
    } catch (e) {
      // If there is an error, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result;

      // Pick an image file using file_picker package
      if (kIsWeb) {
        result = await FilePickerWeb.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);
      } else {
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
      }

      // If user cancels the picker, do nothing
      if (result == null) return false;

      otherFile = result.files.first;
      files[otherFile!.name] = otherFile!.bytes!;

      notifyListeners();
      return true;
    } catch (e) {
      // If there is an error, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }

  void clear() {
    imageFile = null;
    otherFile = null;
    images.clear();
    files.clear();
    notifyListeners();
  }

  void removeImage(String key) {
    images.remove(key);
    if (images.length == 0) {
      imageFile = null;
    }
    notifyListeners();
  }

  void removeFile(String key) {
    files.remove(key);
    if (files.length == 0) {
      otherFile = null;
    }
    notifyListeners();
  }
}
