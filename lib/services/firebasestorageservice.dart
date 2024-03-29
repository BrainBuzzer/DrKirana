import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    String downloadURL = await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    NetworkImage m = NetworkImage(downloadURL);
    return m;
  }
}