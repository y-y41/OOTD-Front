import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madcamp_w2/data/weather_data.dart';
import 'package:madcamp_w2/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  double? currentTemperature;
  Map<int, double>? hourlyTemperatures;

  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = dotenv.env['OPENWHEATHERMAP_API_KEY'] ?? '';

  WeatherData? weatherData;
  WeatherData? todayWeather;
  WeatherData? forecastWeather;
  bool isLoading = false;

  Future<void> fetchTodayWeather(String city) async {
    // isLoading = true;
    // notifyListeners();
    //
    // final url = "$baseUrl?q=$city&appid=$apiKey&units=metric";
    try {
      todayWeather = await WeatherService.getTodayWeather(city);
      notifyListeners();
    } catch (e) {
      print("Error fetching weather data: $e");
      // } finally {
      //   isLoading = false;
      //   notifyListeners();
    }
  }

  Future<void> fetchForecastWeather(String city) async {
    isLoading = true;
    notifyListeners();

    final url = "$baseUrl/forecast?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        forecastWeather = json.decode(response.body);
      } else {
        forecastWeather = null;
        throw Exception("Failed to fetch weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> searchWeather(String city, String date) async {
    final url = "$baseUrl/forecast?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final forecast = json.decode(response.body);
        return forecast['list'].firstWhere(
            (item) => item['dt_txt'].startWith(date),
            orElse: () => null);
      } else {
        throw Exception("Failed to search weather");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      return null;
    }
  }
}
