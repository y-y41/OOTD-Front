import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/widget/satisfaction_button.dart';
import 'package:madcamp_w2/widget/temperature_graph.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location,
                color: ColorChart.ootdTextGrey,
                size: 24,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                '대전광역시',
                style: TextStyle(
                    color: ColorChart.ootdTextGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          Center(
            child: Column(
              children: [
                Text(
                  '체감온도',
                  style: TextStyle(
                      color: ColorChart.ootdTextGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 0.7),
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  '2.6°',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 31,
                      fontWeight: FontWeight.w700,
                      height: 1.2),
                )
              ],
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '비',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '0.0mm',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '습도',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '60 %',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '바람',
                    style: TextStyle(
                        color: ColorChart.ootdTextGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Text(
                    '1.5 m/s',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '일교차',
                style: TextStyle(
                    color: ColorChart.ootdTextGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                width: 170,
                height: 60,
                // color: ColorChart.ootdTextGrey,
                child: TemperatureGraph(
                  values: [-4, 3, 2, -1],
                ),
              )
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추천 OOTD',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorChart.ootdGreen,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorChart.ootdGreen,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorChart.ootdGreen,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorChart.ootdGreen,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 218,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘의 OOTD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900),
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
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '과거의 OOTD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 192,
                      height: 160,
                      decoration: BoxDecoration(
                          color: ColorChart.ootdItemGrey,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '아직 비슷한 날씨의\n과거 OOTD가 없습니다.\n앱을 더 이용해주세요!',
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
                            CupertinoIcons.heart_fill,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // width: MediaQuery.of(context).size.width,
            // height: 50,
            // color: ColorChart.ootdTextGrey,
            child: SatisfactionButton(),
          )
        ],
      ),
    );
  }
}
