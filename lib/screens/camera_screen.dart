import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:madcamp_w2/providers/photo_provider.dart';
import 'package:madcamp_w2/providers/weather_provider.dart';
import 'package:madcamp_w2/widgets/picture_dialog.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  File? capturedImage;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    try {
      final XFile picture = await _cameraController.takePicture();

      setState(() {
        capturedImage = File(picture.path);
      });
      _showPictureDialog(File(picture.path));
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _showPictureDialog(File imageFile) {
    showDialog(
        context: context,
        builder: (context) => PictureDialog(
            imageFile: imageFile,
            onRetake: () {
              Navigator.pop(context);
            },
            onConfirm: () async {
              await _uploadPicture();
              Navigator.pop(context, imageFile);
            }));
  }

  Future<void> _uploadPicture() async {
    if (capturedImage == null) return;

    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final todayWeather = weatherProvider.todayWeather;
    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);
    final photoProvider = Provider.of<PhotoProvider>(context, listen: false);

    try {
      // 1. 백엔드에서 presigned url 요청
      final fileName = capturedImage!.path.split('/').last;
      final preUrlResponse = await http.post(
          Uri.parse(
              'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/generate-presigned-url'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'file_name': fileName, 'file_type': 'image/jpeg'}));

      if (preUrlResponse.statusCode != 200) {
        throw Exception('Failed to get Presigned URL');
      }

      final preUrlData = jsonDecode(preUrlResponse.body);
      final preUrl = preUrlData['presigned_url'];
      final fileUrl = preUrlData['file_url'];

      // 2. presigned url 이용해 S3에 이미지 업로드
      final uploadResponse = await http.put(
        Uri.parse(preUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: capturedImage!.readAsBytesSync(),
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception('Failed to upload image to S3');
      }

      // 3. 백엔드한테 url 전달
      print("kakao ID::::::::::::::::::${kakaoUserInfo.kakaoId}");
      final requestBody = {
        'kakao_id': kakaoUserInfo.kakaoId,
        'date':
            "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
        'location': todayWeather!.cityName,
        'actual_temp': todayWeather.temperature,
        'apparent_temp': todayWeather.feelsLike,
        'precipitation': todayWeather.rainVolume,
        'humidity': todayWeather.humidity,
        'wind_speed': todayWeather.windSpeed,
        'condition': todayWeather.condition,
        'temp_6am': 0.0,
        'temp_12pm': 0.0,
        'temp_6pm': 0.0,
        'temp_12am': 0.0,
        'photo_url': fileUrl
      };
      print('Request Body: ${jsonEncode(requestBody)}');

      // 3. 백엔드한테 url 전달
      final backendResponse = await http.post(
          Uri.parse(
              'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/save-ootd'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      photoProvider.setPhotoUrl(fileUrl);

      if (backendResponse.statusCode != 200) {
        print('Backend Response Status: ${backendResponse.statusCode}');
        print('Backend Response Body: ${backendResponse.body}');
        throw Exception('Failed to save URL to backend');
      }
    } catch (e) {
      print('Error uploading picture: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: Stack(
        children: [
          if (_cameraController.value.isInitialized)
            Positioned.fill(child: CameraPreview(_cameraController)),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: _takePicture,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: ColorChart.ootdTextGrey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
