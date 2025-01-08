import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/config/satisfaction_emoji.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SatisfactionButton extends StatefulWidget {
  const SatisfactionButton({Key? key}) : super(key: key);

  @override
  State<SatisfactionButton> createState() => _SatisfactionButtonState();
}

class _SatisfactionButtonState extends State<SatisfactionButton> {
  bool isExpanded = false;
  String? selectedEmoji;
  String? selectedText;

  final Map<String, String> emojiText = {
    Satisfaction.veryHot: '더웠어요',
    Satisfaction.littleHot: '약간 더웠어요',
    Satisfaction.good: '만족했어요',
    Satisfaction.littleCold: '약간 추웠어요',
    Satisfaction.veryCold: '추웠어요'
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedEmoji();
  }

  Future<void> _loadSelectedEmoji() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedEmoji = prefs.getString('selectedEmoji') ?? Satisfaction.good;
      selectedText = emojiText[selectedEmoji] ?? '오늘의 OOTD만족도를 평가해주새요';
    });
  }

  Future<void> _saveSelectedEmoji(String emoji) async {
    // final prefs = await S
  }

  Future<void> updateSatisfaction(String emoji) async {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final todayWeather = weatherProvider.todayWeather;
    final serverUrl = Uri.parse(
        'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/update-satisfaction');

    var score = 3;
    switch (emoji) {
      case Satisfaction.veryHot:
        score = 1;
        break;
      case Satisfaction.littleHot:
        score = 2;
        break;
      case Satisfaction.good:
        score = 3;
        break;
      case Satisfaction.littleCold:
        score = 4;
        break;
      case Satisfaction.veryCold:
        score = 5;
        break;
    }

    final requestBody = {
      'kakao_id': 3867638125,
      'date':
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      'location': todayWeather!.cityName,
      'satisfaction_score': score
    };

    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.put(serverUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('Satisfaction data successfully sent to the server');
      } else {
        print('Failed to send data to the server');
        print('Error Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending data to the server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 60,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // color: ColorChart.ootdIvory,
          // borderRadius: BorderRadius.circular(30),
          ),
      child: Material(
        color: Colors.transparent,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [isExpanded ? _buildExpanded() : _buildCollapsed()]),
      ),
    );
  }

  Widget _buildExpanded() {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 2),
                blurRadius: 4,
                spreadRadius: 0)
          ]),
      child: Row(children: [
        Image.asset(
          selectedEmoji ?? Satisfaction.good,
          width: 30,
          height: 30,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 1,
          height: 24,
          color: ColorChart.ootdTextGrey,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: emojiText.entries.map((entry) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = entry.key;
                    selectedText = entry.value;
                    isExpanded = false;
                    updateSatisfaction(entry.key);
                  });
                },
                child: Image.asset(
                  entry.key,
                  width: 30,
                  height: 30,
                ));
          }).toList(),
        ))
      ]),
    );
  }

  Widget _buildCollapsed() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 2),
                        blurRadius: 4,
                        spreadRadius: 0)
                  ]),
              child: Center(
                child: Image.asset(
                  selectedEmoji ?? Satisfaction.good,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              selectedText ?? '오늘의 OOTD만족도를 평가해주세요',
              style: TextStyle(
                  color: ColorChart.ootdTextGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
