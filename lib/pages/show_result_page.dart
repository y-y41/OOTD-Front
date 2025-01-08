import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/data/weather_data.dart';
import 'package:madcamp_w2/services/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:madcamp_w2/widgets/ootds/past_OOTD.dart';
import 'package:madcamp_w2/widgets/ootds/recommad_OOTD.dart';
import 'package:madcamp_w2/widgets/temperature_graph.dart';
import 'package:madcamp_w2/data/weather_icon.dart';

class ShowResultPage extends StatefulWidget {
  final String cityName;
  final DateTime? selectedDate;
  final List<double>? temps;

  const ShowResultPage(
      {Key? key,
      required this.cityName,
      required this.selectedDate,
      required this.temps})
      : super(key: key);

  @override
  State<ShowResultPage> createState() => _ShowResultPageState();
}

class _ShowResultPageState extends State<ShowResultPage> {
  WeatherData? weatherData;
  Map<String, dynamic>? forecastData;
  bool isLoading = true;
  String? error;
  String? condition;
  Map<int, double> hourlyTemps = {6: 0.0, 12: 0.0, 18: 0.0, 0: 0.0};
  late List<double> temperatures;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      if (widget.selectedDate != null) {
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(widget.selectedDate!);
        List<Map<String, dynamic>> forecasts =
            await WeatherService.searchWeatherByData(
                widget.cityName, formattedDate);

        forecastData = forecasts.first;

        for (var forecast in forecasts) {
          if (forecast['dt_txt'] != null) {
            final dateTime = DateTime.parse(forecast['dt_txt'].toString());
            final hour = dateTime.hour;
            if ([6, 12, 18, 0].contains(hour)) {
              if (hourlyTemps.containsKey(hour)) {
                final temp = forecast['main']?['temp'];
                if (temp != null) {
                  hourlyTemps[hour] = (temp is int) ? temp.toDouble() : temp;
                  print(
                      "Setting temperature for hour $hour: ${hourlyTemps[hour]}");
                }
              }
            }
          }
        }
        temperatures = hourlyTemps.values.toList();
      } else {
        weatherData = await WeatherService.getTodayWeather(widget.cityName);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildWeatherInfo() {
    if (widget.selectedDate != null && forecastData != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.my_location,
                  color: Colors.black,
                  size: 24,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  widget.cityName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(widget.selectedDate!),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    WeatherIcon[forecastData!['weather'][0]['description']] ??
                        'assets/images/weather_rain.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    width: 5,
                  ),
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
                        '${forecastData!['main']['feels_like']}°',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            height: 1.2),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '실제온도',
                      style: TextStyle(
                          color: ColorChart.ootdTextGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      '${forecastData!['main']['temp']}°',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '비',
                      style: TextStyle(
                          color: ColorChart.ootdTextGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      forecastData!['rain'] != null
                          ? '${forecastData!['rain']['1h']} mm'
                          : '0.0 mm',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      '${forecastData!['main']['humidity']} %',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      '${forecastData!['wind']['speed']} m/s',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '일교차',
                  style: TextStyle(
                      color: ColorChart.ootdTextGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  width: 170,
                  height: 60,
                  // color: ColorChart.ootdTextGrey,
                  child: TemperatureGraph(values: widget.temps ?? temperatures),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            RecommadOotd(
              temperature: forecastData!['main']['temp'],
              feelsLike: forecastData!['main']['feels_like'],
              rainVolume: forecastData!['rain'] != null
                  ? forecastData!['rain']['1h']
                  : 0.0,
              humidity: forecastData!['main']['humidity'],
              windSpeed: forecastData!['wind']['speed'],
              condition: forecastData!['weather'][0]['description'],
              hourlyTemperature: hourlyTemps,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 218,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorChart.ootdIvory,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // TodayOotd(),
                  // SizedBox(
                  //   width: 30,
                  // ),
                  PastOotd(
                    isHome: false,
                    date: widget.selectedDate,
                    feelsLike: forecastData!['main']['feels_like'].toString(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   child: SatisfactionButton(),
            // )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Transform.scale(
          scaleX: 1.4,
          child: Text(
            'OOTD',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: Container(
          color: Colors.white,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
                  ? Text('Error: $error')
                  : SingleChildScrollView(
                      child: _buildWeatherInfo(),
                    )),
    );
  }
}
