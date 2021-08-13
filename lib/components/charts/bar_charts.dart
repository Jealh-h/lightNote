import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BarChartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BarChartState();
  }
}

class BarChartState extends State<BarChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            groupsSpace: 5,
            barGroups: [
              BarChartGroupData(
                x: 1,
                barsSpace: 36,
                showingTooltipIndicators: [5],
                barRods: [
                  BarChartRodData(y: 5),
                ],
              ),
              BarChartGroupData(
                x: 36,
                showingTooltipIndicators: [2],
                barRods: [
                  BarChartRodData(y: 2),
                ],
              )
            ],
          ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear),
    );
  }
}
