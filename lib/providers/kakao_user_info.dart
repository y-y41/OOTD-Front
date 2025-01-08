import 'package:flutter/cupertino.dart';

class KakaoUserInfo with ChangeNotifier {
  int? kakaoId;
  String? nickname;
  String? profileImageUrl;

  void setKakaoUserInfo(int id, String nickname, String profileImageUrl) {
    kakaoId = id;
    this.nickname = nickname;
    this.profileImageUrl = profileImageUrl;
    notifyListeners();
  }

  void clearUserInfo() {
    kakaoId = null;
    nickname = null;
    profileImageUrl = null;
    notifyListeners();
  }
}
