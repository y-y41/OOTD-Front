import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';

class PastOotd extends StatefulWidget {
  const PastOotd({Key? key}) : super(key: key);

  @override
  State<PastOotd> createState() => _PastOotdState();
}

class _PastOotdState extends State<PastOotd> {
  bool _existed = true;

  List<String> imageUrls = [
    'https://via.placeholder.com/90x160.png?text=Image+1',
    'https://via.placeholder.com/90x160.png?text=Image+2',
    'https://via.placeholder.com/90x160.png?text=Image+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '과거의 OOTD',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
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
          child: _existed
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 90,
                          height: 160,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                )
              : Column(
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
    );
  }
}
