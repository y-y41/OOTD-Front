import 'package:flutter/material.dart';

class ShowResultPage extends StatelessWidget {
  final String cityName;
  final DateTime? selectedDate;

  const ShowResultPage(
      {Key? key, required this.cityName, required this.selectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$cityName, $selectedDate');
  }
}
