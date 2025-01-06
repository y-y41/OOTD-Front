import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:madcamp_w2/screens/camera_screen.dart';
import 'package:madcamp_w2/widgets/past_OOTD.dart';
import 'package:madcamp_w2/widgets/recommad_OOTD.dart';
import 'package:madcamp_w2/widgets/satisfaction_button.dart';
import 'package:madcamp_w2/widgets/temperature_graph.dart';
import 'package:madcamp_w2/widgets/today_OOTD.dart';
import 'package:provider/provider.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching weather data ...');
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchTodayWeather('Daejeon');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    if (provider.todayWeather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final weather = provider.todayWeather!;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: ColorChart.ootdTextGrey,
                size: 24,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                weather.cityName,
                style: TextStyle(
                    color: ColorChart.ootdTextGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '체감온도',
                      style: TextStyle(
                          color: ColorChart.ootdTextGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 0.7),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      '${weather.feelsLike}°',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          height: 1.2),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      '실제온도',
                      style: TextStyle(
                          color: ColorChart.ootdTextGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      '${weather.temperature}°',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '비',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '${weather.rainVolume} mm',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '습도',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '${weather.humidity} %',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '바람',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '${weather.windSpeed} m/s',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '일교차',
                style: TextStyle(
                    color: ColorChart.ootdTextGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                width: 170,
                height: 60,
                // color: ColorChart.ootdTextGrey,
                child: TemperatureGraph(
                  values: weather.hourlyTemperature.values.toList(),
                ),
              )
            ],
          ),
          SizedBox(
            height: 14,
          ),
          RecommadOotd(),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 218,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                TodayOotd(),
                SizedBox(
                  width: 30,
                ),
                PastOotd()
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: SatisfactionButton(),
          )
        ],
      ),
    );
  }
}
