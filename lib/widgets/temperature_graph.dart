import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_w2/config/color_chart.dart';

class TemperatureGraph extends StatelessWidget {
  final List<double> values;

  const TemperatureGraph({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double minY =
        values.reduce((min, value) => min < value ? min : value);
    final double maxY =
        values.reduce((max, value) => max > value ? max : value);

    final double padding = (maxY - minY) * 0.1;
    final double adjustedMinY = minY - padding;
    final double adjustedMaxY = maxY + padding;

    return Stack(
      children: [
        SizedBox(
          width: 170,
          height: 60,
          child: LineChart(LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 3,
              minY: adjustedMinY,
              maxY: adjustedMaxY,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, values[0]),
                    FlSpot(1, values[1]),
                    FlSpot(2, values[2]),
                    FlSpot(3, values[3])
                  ],
                  isCurved: false,
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barDara, index) {
                        return FlDotCirclePainter(
                            radius: 3,
                            color: ColorChart.ootdTextGrey,
                            strokeWidth: 0);
                      }),
                  color: ColorChart.ootdTextGrey,
                )
              ])),
        ),
        ...List.generate(4, (index) {
          final double x = index * (170 / 3);
          final double value = values[index];

          final double normalizedY = (value - minY) / (maxY - minY);
          final double yOffset = normalizedY * 40;

          return Positioned(
              left: index == 3 ? null : x - 8,
              right: index == 3 ? 0 : null,
              bottom: yOffset + (value >= 0 ? 35 : 10),
              child: Text(
                '${value.toInt()}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ));
        })
      ],
    );
  }
}
