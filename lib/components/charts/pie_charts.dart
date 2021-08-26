import 'package:flutter/material.dart';
import 'package:lightnote/constants/const.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class PieChartScreen extends StatefulWidget {
  PieChartScreen(this.data, this.time);
  Map data;
  int time;

  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen> {
  int touchedIndex = -1;
  // ignore: unused_field
  late List<ConsumptionData> _data;

  @override
  void initState() {
    // _data = getData();
    super.initState();
  }

  getData() async {
    // _data = widget.data
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
      height: 300,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              spreadRadius: 4,
              color: Color(0xff37434d).withOpacity(0.05)),
        ],
      ),
      child: widget.data["data"] == null
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: CircularProgressIndicator(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "TangYuan"),
                          children: [
                            TextSpan(text: "在"),
                            TextSpan(
                              text: "${widget.time}",
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(text: "年里,你一共消费了"),
                            TextSpan(
                                text: "${widget.data["totalCount"]}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.green)),
                            TextSpan(text: "笔,其中"),
                            TextSpan(
                                text:
                                    "${consumptionType[widget.data["maxType"]]["name"]}",
                                style: TextStyle(color: Colors.blue)),
                            TextSpan(text: "消费了${widget.data["maxOut"]},"),
                            TextSpan(
                              text: "占比最大，为总体的",
                            ),
                            TextSpan(
                                text: "${widget.data["percent"]}%",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red)),
                          ]),
                    ),
                  ),
                )),
                Container(
                  width: 220,
                  child: SfCircularChart(
                    legend: Legend(
                        overflowMode: LegendItemOverflowMode.wrap,
                        // orientation: LegendItemOrientation.vertical,
                        alignment: ChartAlignment.near,
                        position: LegendPosition.bottom,
                        isVisible: true),
                    annotations: [
                      CircularChartAnnotation(
                          widget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(
                              "${consumptionType[widget.data["maxType"]]["name"]}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text('${widget.data["percent"]}%',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    fontSize: 14)),
                          ])),
                    ],
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: [
                      DoughnutSeries(
                          radius: "70%",
                          dataSource: widget.data["data"],
                          explode: true,
                          enableSmartLabels: true,
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside),
                          xValueMapper: (data, _) =>
                              consumptionType[data["type"]]["name"],
                          yValueMapper: (data, _) => data["totalOut"]),
                    ],
                  ),
                ),
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
