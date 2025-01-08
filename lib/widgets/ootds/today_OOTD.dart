import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:madcamp_w2/providers/photo_provider.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:madcamp_w2/screens/camera_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TodayOotd extends StatefulWidget {
  const TodayOotd({Key? key}) : super(key: key);

  @override
  State<TodayOotd> createState() => _TodayOotdState();
}

class _TodayOotdState extends State<TodayOotd> {
  File? _selectedImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _checkForExistingPhoto();
  }

  Future<void> _checkForExistingPhoto() async {
    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final weather = provider.todayWeather!;
    final todayDate =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    final uri = Uri.parse(
            'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/get-ootd-info')
        .replace(queryParameters: {
      'kakao_id': kakaoUserInfo.kakaoId.toString(),
      'date': todayDate,
      'location': weather.cityName
    });

    try {
      final response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photo_url'] != null) {
          setState(() {
            _photoUrl = data['photo_url'];
          });
        }
      } else {
        print('HTTP 요청 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  Future<void> navigateToCamera() async {
    final File? capturedImage = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraScreen()));
    // _checkForExistingPhoto();

    if (capturedImage != null) {
      setState(() {
        _selectedImage = capturedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = Provider.of<PhotoProvider>(context).photoUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 OOTD',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: navigateToCamera,
          child: Container(
              width: 90,
              height: 160,
              decoration: BoxDecoration(
                  color: ColorChart.ootdItemGrey,
                  borderRadius: BorderRadius.circular(15),
                  image: photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(photoUrl!), fit: BoxFit.contain)
                      : _photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_photoUrl!),
                              fit: BoxFit.cover)
                          : null),
              child: _photoUrl == null && photoUrl == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '오늘의\nOOTD를\n추가하세요!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Icon(
                          CupertinoIcons.camera_fill,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    )
                  : null),
        )
      ],
    );
  }
}
