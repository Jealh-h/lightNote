import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartFl extends StatefulWidget {
  const PieChartFl({Key? key}) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChartFl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: SfCartesianChart(
        legend: Legend(position: LegendPosition.bottom, isVisible: true),
        title: ChartTitle(text: "时段收支统计"),
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: "日期"),
        ),
        primaryYAxis: CategoryAxis(
          title: AxisTitle(text: "金额"),
        ),
        series: [
          ColumnSeries(
            name: "支出",
            enableTooltip: true,
            dataSource: data,
            onPointTap: (details) {
              print(details.pointIndex);
            },
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            xValueMapper: (OutcomeData item, _) => item.x,
            yValueMapper: (OutcomeData item, _) => item.y,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class OutcomeData {
  final x;
  final y;
  OutcomeData(this.x, this.y);
}

class IncomeData {
  final x;
  final y;
  IncomeData(this.x, this.y);
}

var data = [
  OutcomeData("星期一", 7),
  OutcomeData("星期二", 1),
  OutcomeData("星期三", 3),
  OutcomeData("星期四", 2),
  OutcomeData("星期五", 1),
  OutcomeData("星期六", 18),
  OutcomeData("星期天", 9),
  OutcomeData("星期天", 9),
  OutcomeData("星期天", 9),
];
