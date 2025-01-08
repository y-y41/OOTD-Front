import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/data/city_data.dart';
import 'package:madcamp_w2/pages/show_result_page.dart';
import 'package:madcamp_w2/services/weather_service.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  String query = '';
  List<MapEntry<String, String>> filteredCities = [];
  final TextEditingController _searchController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // 기본 날짜를 오늘로 설정

  (String city, String country) splitCityCountry(String fullName) {
    final parts = fullName.split(',');
    if (parts.length > 1) {
      return (parts[0].trim(), parts[1].trim());
    }
    return (fullName, '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '위치를 검색하세요',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: ColorChart.ootdTextGrey, width: 3)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        query = value;
                        if (value.isEmpty) {
                          filteredCities = [];
                        } else {
                          filteredCities = cityData.entries
                              .where((entry) =>
                                  entry.value
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  entry.key
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        hintText: '위치를 검색하세요',
                        border: InputBorder.none),
                  ),
                ),
                if (filteredCities.isNotEmpty)
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    constraints: BoxConstraints(maxHeight: 200),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: ColorChart.ootdTextGrey, width: 1)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        return ListTile(
                          title: Text(
                            '${city.key}, ${city.value}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          onTap: () {
                            setState(() {
                              _searchController.text = city.key;
                              filteredCities = [];
                            });
                          },
                        );
                      },
                    ),
                  )
              ],
            ),
          ),
          SizedBox(height: 15),
          // 항상 표시되는 캘린더
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '날짜 선택',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TableCalendar(
                  focusedDay: selectedDate,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2101, 12, 31),
                  selectedDayPredicate: (day) {
                    // 선택된 날인지 확인
                    return isSameDay(selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay; // 선택한 날짜 저장
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowResultPage(
                      cityName: _searchController.text,
                      selectedDate: selectedDate,
                    ),
                  ),
                );
              } else {
                // 에러 메시지 또는 알림 표시
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('도시를 선택하세요.'),
                ));
              }
            },
            child: Text('검색'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
