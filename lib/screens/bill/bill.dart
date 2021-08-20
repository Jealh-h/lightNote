import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lightnote/components/charts/bar_charts.dart';
import 'package:lightnote/components/circle_button.dart';
import 'package:lightnote/screens/bill/bill_index.dart';
import 'package:lightnote/screens/bill/bill_statistics.dart';
import 'package:lightnote/screens/index/index.dart';

class BillScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BillScreenState();
  }
}

class BillScreenState extends State<BillScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          leadingWidth: 40,
          leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: CircleButton(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                // size: 16,
              ),
              press: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Index()),
                );
              },
            ),
          ),
          // 顶部tabbar
          title: Center(
            child: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 5),
                  insets: EdgeInsets.symmetric(horizontal: 24.0)),
              labelStyle: TextStyle(fontSize: 30, fontFamily: "TangYuan"),
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              isScrollable: true,
              unselectedLabelStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              controller: _tabController,
              tabs: const <Widget>[
                Tab(
                  text: "首页",
                ),
                Tab(
                  text: "统计",
                )
              ],
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[BillIndex(), StatisticScreen()],
      ),
    );
  }
}
