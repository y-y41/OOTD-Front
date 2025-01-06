import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/screens/camera_screen.dart';

class TodayOotd extends StatefulWidget {
  const TodayOotd({Key? key}) : super(key: key);

  @override
  State<TodayOotd> createState() => _TodayOotdState();
}

class _TodayOotdState extends State<TodayOotd> {
  File? _selectedImage;

  Future<void> navigateToCamera() async {
    final File? capturedImage = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraScreen()));

    if (capturedImage != null) {
      setState(() {
        _selectedImage = capturedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 OOTD',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: navigateToCamera,
          child: Container(
              width: 90,
              height: 160,
              decoration: BoxDecoration(
                  color: ColorChart.ootdItemGrey,
                  borderRadius: BorderRadius.circular(15),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!), fit: BoxFit.cover)
                      : null),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '오늘의\nOOTD를\n추가하세요!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Icon(
                          CupertinoIcons.camera_fill,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    )
                  : null),
        )
      ],
    );
  }
}
