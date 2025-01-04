import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/screens/today_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [Text('sub1'), TodayScreen(), Text('sub2')];
  var index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: ColorChart.ootdIvory,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
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
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  size: 30,
                ),
                label: '주간'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                label: '오늘'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
                label: '검색'),
          ]),
    );
  }
}
