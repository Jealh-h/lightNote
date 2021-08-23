import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/utils/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartFl extends StatefulWidget {
  const PieChartFl({Key? key}) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChartFl> {
  @override
  void initState() {
    // TODO: implement initState
    getWeekData();
    super.initState();
  }

  List<ComSumData> _income = [];
  List<ComSumData> _outcome = [];
  String startDate = '';
  String endDate = '';
  getWeekData() async {
    var result = await httpPost(uri: baseUrl + "/api/getweekdata");
    if (result["status"] == "success") {
      if (mounted) {
        setState(() {
          for (var i in result["data"]) {
            _income.add(ComSumData(weekdays[i["date"]], i["totalIn"]));
            _outcome.add(ComSumData(weekdays[i["date"]], i["totalOut"]));
          }
          int length = result["data"].length;
          startDate = result["data"][0]["year"].toString() +
              "/" +
              result["data"][0]["month"].toString() +
              "/" +
              result["data"][0]["day"].toString();
          endDate = result["data"][length - 1]["year"].toString() +
              "/" +
              result["data"][length - 1]["month"].toString() +
              "/" +
              result["data"][length - 1]["day"].toString();
        });
      }
      ;
    } else {
      EasyLoading.showError(result["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "最近一周",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "$startDate",
                  ),
                  TextSpan(text: "—"),
                  TextSpan(text: "$endDate"),
                ]),
              ),
            ],
          ),
        ),
        Container(
          width: size.width,
          height: 350,
          child: _income.length == 0
              ? Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SfCartesianChart(
                  legend:
                      Legend(position: LegendPosition.bottom, isVisible: true),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: "日期"),
                  ),
                  primaryYAxis: CategoryAxis(
                    title: AxisTitle(text: "金额"),
                  ),
                  series: [
                    // 收入
                    ColumnSeries(
                        name: "收入",
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xff287ED5),
                              Color(0xff399ED7),
                              Color(0xff3AD0DF),
                              Color(0xffA3F7FB),
                              Color(0xffB1F1F8),
                            ]),
                        spacing: 0.1,
                        enableTooltip: true,
                        dataSource: _income,
                        onPointTap: (details) {
                          print(details.pointIndex);
                        },
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        xValueMapper: (ComSumData item, _) => item.x,
                        yValueMapper: (ComSumData item, _) => item.y,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        markerSettings: MarkerSettings(isVisible: true),
                        selectionBehavior: SelectionBehavior(
                            enable: true, selectedColor: Color(0xff1A7EFE))),
                    // 支出
                    ColumnSeries(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xff47B99A),
                              Color(0xff5BCA7E),
                              Color(0xff76CC52),
                              Color(0xff82CD61),
                              Color(0xffD1F3A9)
                            ]),
                        name: "支出",
                        color: Color(0xffDCD5F5),
                        dataSource: _outcome,
                        onPointTap: (details) {},
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        xValueMapper: (ComSumData item, _) => item.x,
                        yValueMapper: (ComSumData item, _) => item.y,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        markerSettings: MarkerSettings(isVisible: true),
                        selectionBehavior: SelectionBehavior(
                            enable: true, selectedColor: Color(0xff08CBB3))),
                  ],
                ),
        )
      ],
    );
  }
}

class ComSumData {
  final x;
  final y;
  ComSumData(this.x, this.y);
}
