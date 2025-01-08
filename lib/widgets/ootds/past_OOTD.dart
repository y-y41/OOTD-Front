import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/config/satisfaction_emoji.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PastOotd extends StatefulWidget {
  final bool isHome;
  const PastOotd({Key? key, required this.isHome}) : super(key: key);

  @override
  State<PastOotd> createState() => _PastOotdState();
}

class _PastOotdState extends State<PastOotd> {
  bool _existed = true;

  List<String> imageUrls = [];
  List<int> scores = [];

  final Map<int, String> satisfactionImages = {
    1: Satisfaction.veryHot,
    2: Satisfaction.littleHot,
    3: Satisfaction.good,
    4: Satisfaction.littleCold,
    5: Satisfaction.veryCold,
  };

  @override
  void initState() {
    super.initState();
    _fetchPastOotdImages();
  }

  Future<void> _fetchPastOotdImages() async {
    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    final weather = provider.todayWeather!;
    final todayDate =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
            'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/get-similar-ootd')
        .replace(queryParameters: {
      'kakao_id': kakaoUserInfo.kakaoId.toString(),
      'date': todayDate,
      'apparent_temp': weather.feelsLike.toString()
    });

    try {
      print('Fetching data from: $url');

      final response = await http.get(url);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          imageUrls = List<String>.from(
            data['ootd_list'].map((item) => item['photo_url'] as String),
          );
          scores = List<int>.from(data['ootd_list']
              .map((item) => item['satisfaction_score'] as int));
          _existed = imageUrls.isNotEmpty;
        });

        print('Fetched image URLs: $imageUrls');
      } else {
        throw Exception('Failed to load past OOTD images');
      }
    } catch (e, stacktrace) {
      print('Error fetching images: $e');
      print('Stacktrace: $stacktrace');

      setState(() {
        _existed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '과거의 OOTD',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: widget.isHome
              ? MediaQuery.of(context).size.width - 192
              : MediaQuery.of(context).size.width - 72,
          height: 160,
          decoration: BoxDecoration(
              color: _existed ? Colors.transparent : ColorChart.ootdItemGrey,
              borderRadius: BorderRadius.circular(15)),
          child: _existed
              ? ClipRRect(
                  // borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        if (index >= imageUrls.length ||
                            index >= scores.length) {
                          print('Index out of bounds: $index');
                          return SizedBox.shrink(); // 빈 공간으로 대체
                        }

                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: 90,
                                height: 160,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                        left: 10,
                                        bottom: 10,
                                        child: Image.asset(
                                          satisfactionImages[scores[index]]!,
                                          width: 24,
                                          height: 24,
                                        ))
                                  ],
                                ),
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            )
                          ],
                        );
                      }),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '아직 비슷한 날씨의\n과거 OOTD가 없습니다.\n앱을 더 이용해주세요!',
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
                      CupertinoIcons.heart_fill,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
        )
      ],
    );
  }
}
