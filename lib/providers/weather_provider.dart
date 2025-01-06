import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madcamp_w2/data/weather_data.dart';
import 'package:madcamp_w2/services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  WeatherData? todayWeather;
  WeatherData? forecastWeather;
  bool isLoading = false;

  Future<void> fetchTodayWeather(String city) async {
    isLoading = true;
    notifyListeners();

    try {
      todayWeather = await WeatherService.getTodayWeather(city);
      notifyListeners();
    } catch (e) {
      print("Error fetching weather data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchForecastWeather(String city) async {
    isLoading = true;
    notifyListeners();

    try {
      forecastWeather = await WeatherService.getForecastWeather(city);
      notifyListeners();
    } catch (e) {
      print("Error fetching forecast weather data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> searchWeather(String city, String date) async {
    try {
      return await WeatherService.searchWeatherByData(city, date);
    } catch (e) {
      print("Error searching weather data: $e");
      return null;
    }
  }
}
