class WeatherData {
  final String cityName;
  final String condition;
  final double feelsLike;
  final double temperature;
  final double rainVolume;
  final int humidity;
  final double windSpeed;
  final Map<int, double> hourlyTemperature;

  WeatherData({
    required this.cityName,
    required this.condition,
    required this.feelsLike,
    required this.temperature,
    required this.rainVolume,
    required this.humidity,
    required this.windSpeed,
    required this.hourlyTemperature,
  });

  factory WeatherData.fromJson(
      Map<String, dynamic> json, Map<int, double> hourlyTemp) {
    // 안전한 타입 변환을 위한 헬퍼 함수들
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    String toString(dynamic value) {
      if (value == null) return 'Unknown';
      if (value is String) return value;
      return value.toString();
    }

    // main 객체 안전하게 가져오기
    final main = json['main'] ?? {};
    final weather = json['weather'] ?? {};
    final rain = json['rain'] ?? {};
    final wind = json['wind'] ?? {};

    return WeatherData(
      cityName: toString(json['name']),
      condition: toString(weather[0]['description']),
      feelsLike: toDouble(main['feels_like']),
      temperature: toDouble(main['temp']),
      rainVolume: toDouble(rain['1h']),
      humidity: toInt(main['humidity']),
      windSpeed: toDouble(wind['speed']),
      hourlyTemperature: hourlyTemp,
    );
  }

  static Map<int, double> parseHourlyTemperatures(List<dynamic>? forecastList) {
    Map<int, double> hourlyTemps = {
      6: 0.0,
      12: 0.0,
      18: 0.0,
      0: 0.0
    }; // 기본값으로 초기화

    if (forecastList == null) return hourlyTemps;

    try {
      for (var entry in forecastList) {
        if (entry['dt_txt'] != null) {
          final dateTime = DateTime.parse(entry['dt_txt'].toString());
          final hour = dateTime.hour;
          if ([6, 12, 18, 0].contains(hour)) {
            final temp = entry['main']?['temp'];
            if (temp != null) {
              hourlyTemps[hour] = (temp is int) ? temp.toDouble() : temp;
            }
          }
        }
      }
    } catch (e) {
      print("Error parsing hourly temperatures: $e");
    }

    return hourlyTemps;
  }
}
