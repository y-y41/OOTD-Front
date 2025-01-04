import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/config/satisfaction_emoji.dart';

class SatisfactionButton extends StatefulWidget {
  const SatisfactionButton({Key? key}) : super(key: key);

  @override
  State<SatisfactionButton> createState() => _SatisfactionButtonState();
}

class _SatisfactionButtonState extends State<SatisfactionButton> {
  bool isExpanded = false;
  String? selectedEmoji;
  String? selectedText;

  final Map<String, String> emojiText = {
    Satisfaction.veryHot: '더웠어요',
    Satisfaction.littleHot: '약간 더웠어요',
    Satisfaction.good: '만족했어요',
    Satisfaction.littleCold: '약간 추웠어요',
    Satisfaction.veryCold: '추웠어요'
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 60,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // color: ColorChart.ootdIvory,
          // borderRadius: BorderRadius.circular(30),
          ),
      child: Material(
        color: Colors.transparent,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [isExpanded ? _buildExpanded() : _buildCollapsed()]),
      ),
    );
  }

  Widget _buildExpanded() {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 2),
                blurRadius: 4,
                spreadRadius: 0)
          ]),
      child: Row(children: [
        Image.asset(
          selectedEmoji ?? Satisfaction.good,
          width: 30,
          height: 30,
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 1,
          height: 24,
          color: ColorChart.ootdTextGrey,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: emojiText.entries.map((entry) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = entry.key;
                    selectedText = entry.value;
                    isExpanded = false;
                  });
                },
                child: Image.asset(
                  entry.key,
                  width: 30,
                  height: 30,
                ));
          }).toList(),
        ))
      ]),
    );
  }

  Widget _buildCollapsed() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 2),
                        blurRadius: 4,
                        spreadRadius: 0)
                  ]),
              child: Center(
                child: Image.asset(
                  selectedEmoji ?? Satisfaction.good,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              selectedText ?? '오늘의 OOTD만족도를 평가해주세요',
              style: TextStyle(
                  color: ColorChart.ootdTextGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
