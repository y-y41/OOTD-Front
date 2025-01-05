import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:madcamp_w2/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WeatherProvider())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorChart.ootdIvory),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
