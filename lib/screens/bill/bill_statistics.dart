import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/charts/fl_pie_chart.dart';
import 'package:lightnote/components/charts/line_chart.dart';
import 'package:lightnote/components/charts/pie_charts.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/utils/http.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  DateTime _time = DateTime.now();
  int currentYear = DateTime.now().year;
  List yearArr = [];
  Map _data = {
    // "income": [FlSpot(0, 0)],
    // "outcome": [FlSpot(0, 0)]
  };
  Map circleData = {};

  @override
  void initState() {
    setState(() {
      for (int i = _time.year; i >= _time.year - 2; i--) {
        yearArr.add(i);
      }
    });
    getYearData();
    super.initState();
  }

  getYearData() async {
    var result = await httpPost(uri: baseUrl + "/api/getyeardata", param: {
      "year": "$currentYear",
      "month": currentYear != _time.year ? "12" : "${_time.month}"
    });
    var cirResult = await httpPost(
        uri: baseUrl + "/api/getcircledata", param: {"year": "$currentYear"});
    if (result['status'] == 'success' &&
        cirResult["status"] == "success" &&
        mounted) {
      setState(() {
        _data["income"] = result["data"]["income"];
        _data["outcome"] = result["data"]["outcome"];
        circleData = cirResult["data"];
      });
    } else {
      EasyLoading.showError(result["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 周统计
            PieChartFl(),
            // 年统计
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "年度统计",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton(
                      value: currentYear,
                      items: yearArr
                          .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
                                child: Text('$e'),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currentYear = value as int;
                        });
                        print(value);
                      },
                    ),
                  ],
                )),
            LineChartScreen(_data),
            PieChartScreen(circleData, currentYear),
          ],
        ),
      ),
    );
  }
}
