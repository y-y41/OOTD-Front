import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/screens/camera_screen.dart';
import 'package:madcamp_w2/screens/search_screen.dart';
import 'package:madcamp_w2/screens/swipeable_screen.dart';
import 'package:madcamp_w2/screens/today_screen.dart';
import 'package:madcamp_w2/screens/week_screen.dart';
import 'package:madcamp_w2/widgets/hamburger_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [WeekScreen(), TodayScreen(), SearchScreen()];
  var index = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraScreen()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorChart.ootdIvory,
          title: Padding(
            padding: EdgeInsets.only(left: 30),
            child: Transform.scale(
              scaleX: 1.4,
              child: Text(
                'OOTD',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        endDrawer: HamburgerBar(),
        body: Container(
          color: ColorChart.ootdIvory,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: pages[index],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            unselectedItemColor: ColorChart.ootdTextGrey,
            selectedItemColor: ColorChart.ootdGreen,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 0
                        ? 'assets/images/week=on.png'
                        : 'assets/images/week=off.png',
                    width: 22.5,
                    height: 43,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 1
                        ? 'assets/images/cloth=on.png'
                        : 'assets/images/cloth=off.png',
                    width: 60,
                    height: 60,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 2
                        ? 'assets/images/search=on.png'
                        : 'assets/images/search=off.png',
                    width: 27,
                    height: 41,
                  ),
                  label: ''),
            ]),
      ),
    );
  }
}
