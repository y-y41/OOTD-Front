class WeatherData {
  final String cityName;
  final double feelsLike;
  final double temperature;
  final double rainVolume;
  final int humidity;
  final double windSpeed;
  final Map<int, double> hourlyTemperature;

  WeatherData(
      {required this.cityName,
      required this.feelsLike,
      required this.temperature,
      required this.rainVolume,
      required this.humidity,
      required this.windSpeed,
      required this.hourlyTemperature});

  factory WeatherData.fromJson(
      Map<String, dynamic> json, Map<int, double> hourlyTemp) {
    return WeatherData(
      cityName: json['name'],
      feelsLike: json['main']['feels_like'],
      temperature: json['main']['temp'],
      rainVolume: json['rain']?['1h'] ?? 0.0,
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      hourlyTemperature: hourlyTemp,
    );
  }

  static Map<int, double> parseHourlyTemperatures(List<dynamic>? forecastList) {
    if (forecastList == null) {
      print(forecastList);
      return {6: 0.0, 12: 0.0, 18: 0.0, 0: 0.0};
    }

    Map<int, double> hourlyTemps = {};

    for (var entry in forecastList) {
      final dateTime = DateTime.parse(entry['dt_txt']);
      final hour = dateTime.hour;
      if (hour == 6 || hour == 12 || hour == 18 || hour == 0) {
        hourlyTemps[hour] = entry['main']['temp'] ?? 0.0;
      }
    }

    if (hourlyTemps.isEmpty) {
      hourlyTemps = {6: 0.0, 12: 0.0, 18: 0.0, 0: 0.0};
    }
    return hourlyTemps;
  }
}
