// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:madcamp_w2/providers/photo_provider.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:madcamp_w2/screens/home_screen.dart';
import 'package:madcamp_w2/screens/kakao_screen.dart';
import 'package:madcamp_w2/screens/server_test_screen.dart';
import 'package:provider/provider.dart';

// late List<CameraDescription> _cameras;

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PhotoProvider()),
    ChangeNotifierProvider(create: (_) => WeatherProvider()),
    ChangeNotifierProvider(create: (_) => KakaoUserInfo()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OOTD',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorChart.ootdIvory),
        useMaterial3: true,
      ),
      home: const KakaoScreen(),
    );
  }
}
