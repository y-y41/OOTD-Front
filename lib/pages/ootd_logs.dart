import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_w2/config/satisfaction_emoji.dart';
import 'package:madcamp_w2/providers/kakao_user_info.dart';
import 'package:provider/provider.dart';

class OotdLogs extends StatefulWidget {
  const OotdLogs({Key? key}) : super(key: key);

  @override
  State<OotdLogs> createState() => _OotdLogsState();
}

class _OotdLogsState extends State<OotdLogs> {
  List<String> photos = [];
  bool isLoading = true;

  final Map<int, String> satisfactionImages = {
    1: Satisfaction.veryHot,
    2: Satisfaction.littleHot,
    3: Satisfaction.good,
    4: Satisfaction.littleCold,
    5: Satisfaction.veryCold,
  };

  Future<void> fetchPhotos() async {
    final kakaoUserInfo = Provider.of<KakaoUserInfo>(context, listen: false);

    try {
      final response = await http.get(Uri.parse(
              'https://ootd-app-829475977871.asia-northeast3.run.app/api/v1/ootd/get-all-ootds')
          .replace(
              queryParameters: {'kakao_id': kakaoUserInfo.kakaoId.toString()}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // data가 Map이고 photo_list가 존재하는지 확인
        if (data is Map<String, dynamic> && data['photo_list'] != null) {
          setState(() {
            // photo_list를 직접 List<String>으로 변환
            photos = List<String>.from(data['photo_list']);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Transform.scale(
          scaleX: 1.4,
          child: Text(
            'OOTD Log',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 9 / 16),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photoUrl = photos[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.broken_image, size: 50),
                                  );
                                },
                              )),
                        )),
                        // Positioned(
                        //     left: 15,
                        //     bottom: 15,
                        //     child: Image.asset(
                        //       satisfactionImages[photo['satisfaction_score']]!,
                        //       width: 30,
                        //       height: 30,
                        //     ))
                      ],
                    );
                  }),
            ),
    );
  }
}
