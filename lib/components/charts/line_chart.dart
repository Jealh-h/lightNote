import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartScreen extends StatefulWidget {
  LineChartScreen(this.data);
  Map data = {"income": FlSpot(0, 0), "outcome": FlSpot(0, 0)};
  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  List<Color> outcomeColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> incomeColors = [
    Colors.amber,
    Colors.amber.shade700,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data["income"] == null) {
      return Container(
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.40,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 4,
                        color: Color(0xff37434d).withOpacity(0.05)),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ),
          Positioned(
              top: 20,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 30,
                      color: Colors.amber,
                    ),
                    Text("收入"),
                    Container(
                      height: 4,
                      width: 30,
                      margin: EdgeInsets.only(left: 20),
                      color: Color(0xff02d39a),
                    ),
                    Text("支出"),
                  ],
                ),
              ))
        ],
      );
    }
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d).withOpacity(0.05),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d).withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(showTitle: true, titleText: "金额")),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context) => TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'JAN';
              case 2:
                return 'FEB';
              case 3:
                return 'MAR';
              case 4:
                return 'APR';
              case 5:
                return 'MAR';
              case 6:
                return 'JUN';
              case 7:
                return 'JUL';
              case 8:
                return 'AUG';
              case 9:
                return 'SEP';
              case 10:
                return 'OCT';
              case 11:
                return 'NOV';
              case 10:
                return 'DEC';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 50,
          // checkToShowTitle: (min, max, sideTitles, applyedInterval, v) {
          //   if (v == max || v == min)
          //     return true;
          //   else if (v == 500) {
          //     return true;
          //   } else if (v == 1000) {
          //     return true;
          //   } else if (v == 1600) {
          //     return true;
          //   } else if (v == 5200) {
          //     return true;
          //   } else if (v == 12000) {
          //     return true;
          //   } else if (v == 24000) {
          //     return true;
          //   }
          //   return false;
          // },

          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(
              color: const Color(0xff37434d).withOpacity(0.05), width: 1)),
      // minX: 0,
      // maxX: 11,
      // minY: 0,
      // maxY: 6,
      lineBarsData: [
        // 收入
        LineChartBarData(
          show: true,
          spots: widget.data["income"] == null
              ? [FlSpot(0, 0)]
              : widget.data["income"]
                  .map<FlSpot>(
                    (e) => FlSpot(
                      e["month"].toDouble(),
                      e["value"].toDouble(),
                    ),
                  )
                  .toList(),
          isCurved: false,
          colors: incomeColors,
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                incomeColors.map((color) => color.withOpacity(0.6)).toList(),
          ),
        ),
        // 支出
        LineChartBarData(
          spots: widget.data["outcome"] == null
              ? [FlSpot(0, 0)]
              : widget.data["outcome"]
                  .map<FlSpot>(
                    (e) => FlSpot(
                      e["month"].toDouble(),
                      e["value"].toDouble(),
                    ),
                  )
                  .toList(),
          isCurved: true,
          // curveSmoothness: 0.1,
          preventCurveOverShooting: true,
          colors: outcomeColors,
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                outcomeColors.map((color) => color.withOpacity(0.6)).toList(),
          ),
        ),
      ],
    );
  }
}
