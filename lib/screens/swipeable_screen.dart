import 'package:flutter/material.dart';
import 'package:madcamp_w2/screens/camera_screen.dart';
import 'package:madcamp_w2/screens/today_screen.dart';

class SwipeableScreen extends StatelessWidget {
  SwipeableScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          _pageController.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: PageView(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        children: [TodayScreen(), CameraScreen()],
      ),
    );
  }
}
