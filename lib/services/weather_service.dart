import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/data/weather_data.dart';

class WeatherService {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String foreUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const String apiKey = 'e095223b0984d3707444e028c48e00b6';

  static Future<WeatherData> getTodayWeather(String city) async {
    // final url = "$foreUrl?q=$city&appid=$apiKey&units=metric";
    // final response = await http.get(Uri.parse(url));

    final forecastUrl = "$foreUrl?q=$city&appid=$apiKey&units=metric";
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (forecastResponse.statusCode == 200) {
      // final data = json.decode(response.body);
      final foreData = json.decode(forecastResponse.body);
      final List<dynamic> forecastList = foreData['list'];

      // final today = DateTime.now();
      // final todayDateString =
      //     "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      //
      // final selectedTimes = ['06:00:00', '12:00:00', '18:00:00', '00:00:00'];
      // final todayWeather = forecastList.where((item) {
      //   final dateTimeString = item['dt_txt'] as String;
      //   return dateTimeString.startsWith(todayDateString) &&
      //       selectedTimes.contains(dateTimeString.substring(11));
      // }).toList();
      //
      // // final hourlyTemp = WeatherData.parseHourlyTemperatures(foreData['list']);
      // // return WeatherData.fromJson(data, hourlyTemp);
      // final hourlyTemp = WeatherData.parseHourlyTemperatures(todayWeather);
      // return WeatherData.fromJson(todayWeather.first, hourlyTemp);
      final now = DateTime.now();

      // 3시간 간격으로 4개의 데이터를 저장
      final List<Map<String, dynamic>> next4TimeSlots = [];
      for (int i = 0; i < 4; i++) {
        final targetTime = now.add(Duration(hours: i * 3));
        final closestEntry = forecastList.firstWhere(
          (item) {
            final dateTime = DateTime.parse(item['dt_txt']);
            return dateTime.isAfter(targetTime) ||
                dateTime.isAtSameMomentAs(targetTime);
          },
          orElse: () => null,
        );

        if (closestEntry != null) {
          next4TimeSlots.add(closestEntry);
        }
      }

      // 각 시간대의 기온을 따로 추출
      final hourlyTemperatures =
          next4TimeSlots.map((item) => item['main']['temp'] as double).toList();

      final Map<int, double> hTemps = {
        6: hourlyTemperatures[0],
        12: hourlyTemperatures[1],
        18: hourlyTemperatures[2],
        0: hourlyTemperatures[3]
      };

      // 필요한 데이터를 WeatherData에 전달
      return WeatherData.fromJson(next4TimeSlots.first, hTemps);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  static Future<WeatherData> getForecastWeather(String city) async {
    final url = "$baseUrl?q=$city&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    final forecastUrl = "$foreUrl?q=$city&appid=$apiKey&units=metric";
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
      final data = json.decode(response.body);
      final foreData = json.decode(forecastResponse.body);
      final Map<String, dynamic> combinedData = {
        ...data,
        'hourly_forecast': foreData['list'],
      };

      final hourlyTemp = WeatherData.parseHourlyTemperatures(foreData['list']);
      return WeatherData.fromJson(data, hourlyTemp);
    } else {
      throw Exception("Failed to load forecast weather data");
    }
  }

  static Future<List<Map<String, dynamic>>> searchWeatherByData(
      String city, String date) async {
    final forecastUrl = "$foreUrl?q=$city&appid=$apiKey&units=metric";
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (forecastResponse.statusCode == 200) {
      final forecast = json.decode(forecastResponse.body);
      final List<dynamic> forecastList = forecast['list'];

      final weatherOnDate = forecastList
          .where(
            (item) => (item['dt_txt'] as String).startsWith(date),
          )
          .toList();
      return weatherOnDate.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to search weather data");
      // return [];
    }
  }
}
