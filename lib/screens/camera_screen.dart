import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/widgets/picture_dialog.dart';

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
            onConfirm: () {
              _uploadPicture();
              Navigator.pop(context, imageFile);
            }));
  }

  Future<void> _uploadPicture() async {
    if (capturedImage == null) return;

    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('backend upload api'));
      request.files.add(await http.MultipartFile.fromPath(
        'api에서 사용하는 파일 키? 이름',
        capturedImage!.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Uploaded successfully: $responseBody');
        // TODO: url반환받아서 처리 -> 화면에 표시? DB저장?
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload successful!')));
      } else {
        print('Upload failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.statusCode}')));
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
