import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/data/weather_data.dart';
import 'package:madcamp_w2/data/weather_icon.dart';
import 'package:madcamp_w2/pages/show_result_page.dart';
import 'package:madcamp_w2/screens/today_screen.dart';
import 'package:madcamp_w2/services/weather_service.dart';
import 'package:madcamp_w2/widgets/temperature_graph.dart';
import 'package:http/http.dart' as http;

class WeekScreen extends StatefulWidget {
  const WeekScreen({Key? key}) : super(key: key);

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  List<Map<String, dynamic>> weekData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeekData();
  }

  Future<void> fetchWeekData() async {
    try {
      setState(() {
        isLoading = true;
      });

      WeatherData forecastWeather =
          await WeatherService.getForecastWeather("Daejeon");
      final forecastUrl =
          "${WeatherService.foreUrl}?q=Daejeon&appid=${WeatherService.apiKey}&units=metric";
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (forecastResponse.statusCode == 200) {
        final foreData = json.decode(forecastResponse.body);
        final List<dynamic> forecastList = foreData['list'];

        final weekdays = ['월', '화', '수', '목', '금', '토', '일'];

        Map<String, Map<String, dynamic>> dailyTemps = {};
        for (var item in forecastList) {
          final dateTime = DateTime.parse(item['dt_txt']);
          final today = DateTime.now();
          final tommorow = today.add(Duration(days: 1));

          String dayLabel;
          if (dateTime.day == today.day &&
              dateTime.month == today.month &&
              dateTime.year == today.year) {
            dayLabel = '오늘';
          } else if (dateTime.day == tommorow.day &&
              dateTime.month == tommorow.month &&
              dateTime.year == tommorow.year) {
            dayLabel = '내일';
          } else {
            dayLabel = weekdays[dateTime.weekday - 1];
          }

          String condition = item['weather'][0]['description'];
          // String iconID = item['weather'][0]['icon'];
          double temperature = item['main']['temp'].toDouble();

          if (!dailyTemps.containsKey(dayLabel)) {
            dailyTemps[dayLabel] = {
              "condition": condition,
              // 'iconID': iconID,
              'temperatures': <double>[],
            };
          }
          dailyTemps[dayLabel]!["temperatures"]!.add(temperature);
        }
        setState(() {
          weekData = dailyTemps.entries
              .take(5)
              .map((entry) => {
                    "day": entry.key,
                    "condition": entry.value['condition'],
                    // 'iconID': entry.value['iconID'],
                    "temperatures": entry.value['temperatures']
                  })
              .toList();

          // setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching weekly data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: weekData.length,
            itemBuilder: (context, index) {
              final dayData = weekData[index];

              DateTime selectedDate;
              if (dayData['day'] == '오늘') {
                selectedDate = DateTime.now();
              } else if (dayData['day'] == '내일') {
                selectedDate = DateTime.now().add(Duration(days: 1));
              } else {
                selectedDate = _getDateForDay(dayData['day']);
              }
              return Column(
                children: [
                  weekCard(
                    context,
                    day: dayData['day'],
                    condition: dayData['condition'],
                    // iconID: dayData['iconID'],
                    temperatures: dayData['temperatures'],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowResultPage(
                                  cityName: 'Daejeon',
                                  selectedDate: selectedDate)));
                    },
                  ),
                  SizedBox(
                    height: 9,
                  ),
                ],
              );
            });
  }

  Widget weekCard(BuildContext context,
      {required String day,
      required String condition,
      // required String iconID,
      required List<double> temperatures,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 39,
              child: Text(
                day,
                style: TextStyle(
                    color: (day == '토')
                        ? Colors.blue
                        : (day == '일')
                            ? Colors.red
                            : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              // height: 56,
              width: 44,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    WeatherIcon[condition] ?? 'assets/images/weather_rain.png',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    condition,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: TemperatureGraph(
                values: temperatures,
              ),
            )
          ],
        ),
      ),
    );
  }

  DateTime _getDateForDay(String day) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final today = DateTime.now();
    int targetWeekday = weekdays.indexOf(day) + 1;

    int currentWeekday = today.weekday;

    int difference = targetWeekday - currentWeekday;
    if (difference < 0) {
      difference += 7;
    }

    return today.add(Duration(days: difference));
  }
}
