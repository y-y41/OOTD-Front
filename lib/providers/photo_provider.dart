import 'package:flutter/material.dart';

class PhotoProvider with ChangeNotifier {
  String? _photoUrl;

  String? get photoUrl => _photoUrl;

  void setPhotoUrl(String url) {
    _photoUrl = url;
    notifyListeners();
  }
}
