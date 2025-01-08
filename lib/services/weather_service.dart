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
    final url = "$baseUrl?q=$city&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    final forecastUrl = "$foreUrl?q=$city&appid=$apiKey&units=metric";
    final forecastResponse = await http.get(Uri.parse(forecastUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final foreData = json.decode(forecastResponse.body);
      final hourlyTemp = WeatherData.parseHourlyTemperatures(foreData['list']);
      return WeatherData.fromJson(data, hourlyTemp);
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
