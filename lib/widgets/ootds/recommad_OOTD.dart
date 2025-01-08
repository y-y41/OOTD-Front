import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:http/http.dart' as http;

class RecommadOotd extends StatefulWidget {
  final double temperature;
  final double feelsLike;
  final double rainVolume;
  final int humidity;
  final double windSpeed;
  final String condition;
  final Map<int, double> hourlyTemperature;

  const RecommadOotd({
    Key? key,
    required this.temperature,
    required this.feelsLike,
    required this.rainVolume,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.hourlyTemperature,
  }) : super(key: key);

  @override
  State<RecommadOotd> createState() => _RecommadOotdState();
}

class _RecommadOotdState extends State<RecommadOotd> {
  Map<String, String> recommands = {
    'outer': '없음',
    'top': '없음',
    'bottom': '없음',
    'shoes': '없음'
  };

  Future<void> fetchRecommands() async {
    final url = Uri.parse(
        'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/recommendation/generate-recommendation');
    final requestBody = {
      'actual_temp': widget.temperature ?? 0,
      'apparent_temp': widget.feelsLike ?? 0,
      'precipitation': widget.rainVolume ?? 0,
      'humidity': widget.humidity ?? 0,
      'wind_speed': widget.windSpeed ?? 0,
      'condition': widget.condition ?? 'clear sky',
      'temp_6am': widget.hourlyTemperature['6'] ?? 0.0,
      'temp_12pm': widget.hourlyTemperature['12'] ?? 0.0,
      'temp_6pm': widget.hourlyTemperature['18'] ?? 0.0,
      'temp_12am': widget.hourlyTemperature['0'] ?? 0.0
    };
    print('Request Body: $requestBody');
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodeResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodeResponse);

        print('recommend data가 왔어요 왔어 $data');
        setState(() {
          recommands['outer'] = data['outer'] ?? '없음';
          recommands['top'] = data['top'] ?? '없음';
          recommands['bottom'] = data['bottom'] ?? '없음';
          recommands['shoes'] = data['shoes'] ?? '없음';
        });
      } else {
        print('Error: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecommands();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 OOTD',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRecommendation(
                  'assets/images/jacket.png', recommands['outer']!),
              buildRecommendation(
                  'assets/images/shirts.png', recommands['top']!),
              buildRecommendation(
                  'assets/images/pants.png', recommands['bottom']!),
              buildRecommendation(
                  'assets/images/shoes.png', recommands['shoes']!)
            ],
          )
        ],
      ),
    );
  }

  Widget buildRecommendation(String iconUrl, String item) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              color: ColorChart.ootdGreen,
              borderRadius: BorderRadius.circular(50)),
          child: Center(
              child: Image.asset(
            iconUrl,
            width: 40,
            height: 40,
          )),
        ),
        Container(
          width: 58,
          height: 40,
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
