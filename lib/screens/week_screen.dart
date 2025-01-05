import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/screens/today_screen.dart';
import 'package:madcamp_w2/widgets/temperature_graph.dart';

class WeekScreen extends StatelessWidget {
  const WeekScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        weekCard(
          context,
          day: '오늘',
          condition: 'clear sky',
          temperatures: [-3, 4, 3, -1],
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodayScreen()));
          },
        ),
        SizedBox(
          height: 9,
        ),
        weekCard(
          context,
          day: '내일',
          condition: 'clear sky',
          temperatures: [-3, 4, 3, -1],
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodayScreen()));
          },
        ),
        SizedBox(
          height: 9,
        ),
        weekCard(
          context,
          day: '요일',
          condition: 'clear sky',
          temperatures: [-3, 4, 3, -1],
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodayScreen()));
          },
        ),
        SizedBox(
          height: 9,
        ),
        weekCard(
          context,
          day: '요일',
          condition: 'clear sky',
          temperatures: [-3, 4, 3, -1],
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodayScreen()));
          },
        ),
        SizedBox(
          height: 9,
        ),
        weekCard(
          context,
          day: '요일',
          condition: 'clear sky',
          temperatures: [-3, 4, 3, -1],
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodayScreen()));
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget weekCard(BuildContext context,
      {required String day,
      required String condition,
      required List<double> temperatures,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 39,
              child: Text(
                day,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              height: 56,
              width: 42,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    condition,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: TemperatureGraph(
                values: temperatures,
              ),
            )
          ],
        ),
      ),
    );
  }
}
