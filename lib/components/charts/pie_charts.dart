import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PieChartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen> {
  int touchedIndex = -1;
  late List<ConsumptionData> _data;

  @override
  void initState() {
    // TODO: implement initState
    _data = getData();
    super.initState();
  }

  getData() {
    List<ConsumptionData> data = [
      ConsumptionData("交通", 100),
      ConsumptionData("餐饮", 756),
      ConsumptionData("服饰", 555),
      ConsumptionData("其他", 324.20)
    ];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: 200,
      child: SfCircularChart(
        title: ChartTitle(text: '消费类型比例图'),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<ConsumptionData, String>(
              dataSource: _data,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              xValueMapper: (ConsumptionData data, _) => data.type,
              yValueMapper: (ConsumptionData data, _) => data.value),
        ],
      ),
    );
  }
}

class ConsumptionData {
  double value;
  String type;
  ConsumptionData(this.type, this.value);
}
