import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:web_admin_isef/helpers/utils_helpers.dart';

class FirebaseStorageService {
  var storage = FirebaseStorage.instance;

  Future<String?> uploadFile(
      String folder, String name, List<int> bytes) async {
    String rnd = getRandomString(name.length);
    final fileRef = storage.ref("$folder/$rnd-$name");
    try {
      await fileRef.putData(Uint8List.fromList(bytes));
    } on firebase_core.FirebaseException catch (_) {
      return null;
    }

    return await fileRef.getDownloadURL();
  }
}
