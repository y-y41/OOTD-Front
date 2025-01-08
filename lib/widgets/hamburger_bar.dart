import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/pages/ootd_logs.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:provider/provider.dart';

class HamburgerBar extends StatelessWidget {
  const HamburgerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);
    final profileImageUrl = kakaoUserInfo.profileImageUrl ??
        'https://www.example.com/default_image.png';
    final nickname = kakaoUserInfo.nickname ?? 'Guest';

    return Drawer(
      backgroundColor: ColorChart.ootdIvory,
      child: ListView(
        padding: EdgeInsets.only(top: 30),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(profileImageUrl), fit: BoxFit.cover)),
            ),
            accountName: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                // Text(
                //   "'s closet",
                //   style: TextStyle(
                //       color: ColorChart.ootdGreen,
                //       fontSize: 18,
                //       fontWeight: FontWeight.w500),
                // )
              ],
            ),
            accountEmail: null,
            decoration: BoxDecoration(color: ColorChart.ootdIvory),
          ),
          ListTile(
            title: Text(
              '마이페이지',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'OOTD LOG',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => OotdLogs()));
            },
          )
        ],
      ),
    );
  }
}
