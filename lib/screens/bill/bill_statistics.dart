import 'package:flutter/material.dart';
import 'package:lightnote/components/charts/bar_charts.dart';
import 'package:lightnote/components/charts/pie_charts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [PieChartScreen(), BarChartScreen()],
      ),
    ));
  }
}
