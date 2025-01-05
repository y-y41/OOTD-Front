import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';

class TodayOotd extends StatefulWidget {
  const TodayOotd({Key? key}) : super(key: key);

  @override
  State<TodayOotd> createState() => _TodayOotdState();
}

class _TodayOotdState extends State<TodayOotd> {
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
        Container(
          width: 90,
          height: 160,
          decoration: BoxDecoration(
              color: ColorChart.ootdItemGrey,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
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
          ),
        )
      ],
    );
  }
}
