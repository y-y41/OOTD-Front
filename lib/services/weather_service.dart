import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madcamp_w2/data/weather_data.dart';

class WeatherService {
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String foreUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const String apiKey = 'e095223b0984d3707444e028c48e00b6';

  static Future<WeatherData> getTodayWeather(String city) async {
    final url = "$baseUrl?q=$city&appid=$apiKey&units=metric&lang=kr";
    final response = await http.get(Uri.parse(url));

    final forecastUrl = "$foreUrl?q=$city&appid=$apiKey&units=metric&lang=kr";
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
}
