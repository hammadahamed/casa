// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  static Future<File?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      return null;
    }
  }
}

class StoreController {
  static const String USER = "USER_DATA";
  static const String ALBUMS = "USER_ALBUMS";
  static const String POSTS = "USER_POSTS";

  static const String PHOTOS = "PHOTOS";

  static const String COMMENTS = "COMMENTS";

  static String getPhotosPath({required int albumId}) {
    return "$ALBUMS/$albumId/$PHOTOS";
  }

  static String getCommentsPath({required int postId}) {
    return "$POSTS/$postId/$COMMENTS";
  }

  static saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
