import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';
import 'package:madcamp_w2/data/city_data.dart';
import 'package:madcamp_w2/pages/show_result_page.dart';
import 'package:madcamp_w2/services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List<MapEntry<String, String>> filteredCities = [];
  final TextEditingController _searchController = TextEditingController();

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
            // height: 120,
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
                        // final (cityName, countryName) =
                        //     splitCityCountry(city.value);

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShowResultPage(cityName: city.value)));
                          },
                        );
                      },
                    ),
                  )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
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
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '날짜를 선택하세요',
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
                  height: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                      color: ColorChart.ootdGreen,
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
