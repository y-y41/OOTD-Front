import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:madcamp_w2/screens/home_screen.dart';
import 'package:provider/provider.dart';

enum LoginPlatform {
  facebook,
  google,
  kakao,
  naver,
  apple,
  none, // logout
}

class KakaoScreen extends StatefulWidget {
  const KakaoScreen({Key? key}) : super(key: key);

  @override
  State<KakaoScreen> createState() => _KakaoScreenState();
}

class _KakaoScreenState extends State<KakaoScreen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
      });

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      final serverUrl = Uri.parse(
          'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/auth/save-user-info');
      final userInfo = {
        'kakao_id': profileInfo['id'],
        'nickname': profileInfo['properties']['nickname'],
        'profile_image': profileInfo['properties']['profile_image']
      };

      try {
        final serverResponse = await http.post(serverUrl,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userInfo));
        print('Response: ${serverResponse.body}');
        if (serverResponse.statusCode == 200) {
          setState(() {
            _loginPlatform = LoginPlatform.kakao;
          });

          final kakaoUserInfo =
              Provider.of<KakaoUserInfo>(context, listen: false);
          kakaoUserInfo.setKakaoUserInfo(
              profileInfo['id'],
              profileInfo['properties']['nickname'],
              profileInfo['properties']['profile_image']);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          print('Faile to send data to the server');
        }
      } catch (e) {
        print('Error: $e');
      }

      // setState(() {
      //   _loginPlatform = LoginPlatform.kakao;
      // });
      //
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print('카카오톡 로그인 실패 $e');
    }
  }

  void signOut() async {
    await UserApi.instance.logout();
    setState(() {
      _loginPlatform = LoginPlatform.none;
    });

    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);
    kakaoUserInfo.clearUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? _logoutButton()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _loginButton(
                      'kakao_login',
                      signInWithKakao,
                    )
                  ],
                )),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}
