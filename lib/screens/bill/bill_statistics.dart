import 'package:flutter/material.dart';
import 'package:lightnote/components/charts/bar_charts.dart';
import 'package:lightnote/components/charts/fl_pie_chart.dart';
import 'package:lightnote/components/charts/pie_charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            PieChartFl(),
            PieChartScreen(),
            BarChartScreen(),
          ],
        ),
      ),
    );
  }
}
