import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';

class RecommadOotd extends StatelessWidget {
  const RecommadOotd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 OOTD',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
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
    );
  }
}
