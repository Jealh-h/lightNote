import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BarChartState();
  }
}

class BarChartState extends State<BarChartScreen> {
  late List data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var rand = Random();
    for (int i = 0; i < 5; i++) {
      data.add({"yAxis": rand.nextDouble() * 10, "xAxis": i});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: BarChart(
          BarChartData(
            // 设置为center对齐，才能使groupsSpace生效
            alignment: BarChartAlignment.center,
            maxY: 10,
            // barGroups之间距离
            groupsSpace: 16,
            barGroups: data.map((e) {
              return BarChartGroupData(
                x: e["xAxis"],
                // 一个组内，各个barRod之间的间距
                barsSpace: 3,
                // 在BarChartRodData头上显示tooltip，
                // 数组放一个组内rodData的下标，表示要在一个组内哪一个柱状图上显示
                showingTooltipIndicators: [0],
                barRods: [
                  BarChartRodData(
                    y: e["yAxis"],
                    width: 15,
                    // 设置多组颜色会形成渐变
                    colors: [Color(0xff43CAF2), Color(0xff64F0AC)],
                    gradientColorStops: [],
                    gradientFrom: Offset(0, 1),
                    gradientTo: Offset(0, 0),
                    // borderRadius: BorderRadius.circular(20),

                    // 让bar的空余部分显示,并设置其显示背景色
                    backDrawRodData: BackgroundBarChartRodData(
                      y: 10,
                      show: false,
                      colors: [Colors.amber],
                    ),
                    // 用于在一个柱状图上绘制多段颜色，需要把colors属性注释掉
                    rodStackItems: [
                      BarChartRodStackItem(0, 3, Colors.red),
                      BarChartRodStackItem(3, 6, Colors.green),
                      BarChartRodStackItem(6, 9, Colors.blue),
                    ],
                  ),
                  BarChartRodData(
                    y: 9,
                    width: 15,
                    // colors: [Color(0xff43CAF2), Color(0xff64F0AC)],
                    // gradientColorStops: [e["yAxis"]],
                    // gradientFrom: Offset(e["xAxis"].toDouble(), 1),
                    // gradientTo: Offset(e["xAxis"].toDouble(), 1),
                    // borderRadius: BorderRadius.circular(20),

                    // 让bar的空余部分显示背景色
                    backDrawRodData: BackgroundBarChartRodData(
                      y: 10,
                      show: false,
                      colors: [Colors.amber],
                    ),
                    rodStackItems: [
                      BarChartRodStackItem(0, 3, Colors.red),
                      BarChartRodStackItem(3, 6, Colors.green),
                      BarChartRodStackItem(6, 9, Colors.blue),
                    ],
                  ),
                ],
              );
            }).toList(),
            // 坐标轴上的刻度设置
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                  // 格式化axis
                  getTitles: (text) {
                    return "${text.toInt()}周";
                  },
                  // 设置字体颜色
                  getTextStyles: (text) {
                    return TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue);
                  },
                  // 倾斜，旋转
                  rotateAngle: 45,
                  showTitles: true),
              leftTitles: SideTitles(
                  // 格式化axis
                  getTitles: (text) {
                    return "${text.toInt()}";
                  },
                  // 设置字体颜色
                  getTextStyles: (text) {
                    return TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue);
                  },
                  // 倾斜，旋转
                  rotateAngle: -45,
                  showTitles: true),
              rightTitles: SideTitles(
                  // 格式化axis
                  getTitles: (text) {
                    return "${text.toInt()}";
                  },
                  // 设置字体颜色
                  getTextStyles: (text) {
                    return TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue);
                  },
                  // 倾斜，旋转
                  rotateAngle: -45,
                  showTitles: true),
            ),
            // 上下左右标题
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                  margin: 25,
                  titleText: "柱状图",
                  showTitle: true,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
              bottomTitle: AxisTitle(titleText: "bottomTitle", showTitle: true),
              leftTitle: AxisTitle(
                  titleText: "leftTitle", showTitle: true, reservedSize: 20),
              rightTitle: AxisTitle(
                titleText: "rightTitle",
                showTitle: true,
                reservedSize: 20,
              ),
            ),
            // 范围注释
            rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations: [
              // HorizontalRangeAnnotation(y1: 1, y2: 2, color: Colors.amber),
            ], verticalRangeAnnotations: [
              // VerticalRangeAnnotation(x1: 0, x2: 0.5, color: Colors.blue)
            ]),

            // 图表背景颜色
            backgroundColor: Color(0xff2D4261),
            // barTouch数据,点击每个bar显示数据的样式
            barTouchData: BarTouchData(
              enabled: true,
              // 触摸精度阈值
              touchExtraThreshold: EdgeInsets.all(4),
              // 是否允许触摸bar的背景，触发触摸事件
              allowTouchBarBackDraw: false,
              // 触摸bar是否显示提示框
              handleBuiltInTouches: true,
              // 触摸bar回调函数
              touchCallback: (barTouchResponse) {
                print(barTouchResponse.touchInput);
              },
              // 触摸提示的内容区域
              touchTooltipData: BarTouchTooltipData(
                  // 背景颜色
                  tooltipBgColor: Colors.grey.shade800,
                  // 圆角radius
                  tooltipRoundedRadius: 10,
                  // padding
                  tooltipPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  // margin
                  tooltipMargin: 10,
                  // maxContextWidth
                  maxContentWidth: 120,
                  // 提示框显示，相当于格式化显示
                  getTooltipItem:
                      (barChartGroupData, int_1, barChartRodData, int_2) {
                    return BarTooltipItem(
                        barChartRodData.y.toStringAsPrecision(2),
                        TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        children: []);
                  }),
            ),
            // gridData表格
            gridData: FlGridData(
              drawVerticalLine: true,
              drawHorizontalLine: false,
              getDrawingHorizontalLine: (line) {
                return FlLine(
                    // color: Colors.white,
                    // strokeWidth: 1,
                    // dashArray: [5, 10],
                    );
              },
            ),
            // BorderData,图表的边框
            borderData: FlBorderData(
              border: Border.all(
                  color: Colors.amber, width: 2, style: BorderStyle.values[1]),
            ),
          ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear),
    );
  }
}
