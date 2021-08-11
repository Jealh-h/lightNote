import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/screens/amap_location/amap.dart';
import 'package:lightnote/screens/profille/profile.dart';
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';
import 'dart:ui';

import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/print_utils.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

class IndexHome extends StatefulWidget {
  TextStyle dateTextStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [Shadow(offset: Offset(0, 2), color: Colors.black54)],
  );
  @override
  State<StatefulWidget> createState() {
    return IndexStateScreen();
  }
}

class IndexStateScreen extends State<IndexHome> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double radius = 0;
  String _time = '';
  String _date = '';
  Timer? _timer = null;

  bool isDrawerOpen = false;

  Map<String, dynamic> weatherInfo = {
    "status": 1,
    "count": 1,
    "info": "OK",
    "infocode": 10000,
    "lives": [
      {
        "province": "北京",
        "city": "东城区",
        "adcode": 110101,
        "weather": "多云",
        "temperature": 30,
        "winddirection": "东北",
        "windpower": "≤3",
        "humidity": 49,
        "reporttime": "2021-08-11 15:08:25"
      }
    ]
  };
  @override
  void initState() {
    getWeather();
    setTimer();
    setState(() {
      weatherInfo;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

// 获取天气
  getWeather() async {
    weatherInfo = await httpGet('restapi.amap.com', '/v3/weather/weatherInfo',
        {"key": "25d3dafaaf101d84a39d5670e2d74d2f", "city": "110101"});
  }

// 设置时间
  setTime() {
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;
    var month = DateTime.now().month;
    var day = DateTime.now().day;
    var week = weekdays[DateTime.now().weekday % 7];
    print(DateTime.now());
    setState(() {
      if (minute < 10)
        _time = "${hour}:0${minute}";
      else
        _time = "${hour}:${minute}";
      _date = "$month月$day日 $week";
    });
  }

  // 设置定时器，实时刷新时间
  setTimer() {
    setTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setTime();
      // timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      // ..级联操作符
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor),
      alignment: Alignment.topLeft,
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          // 菜单行
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      yOffset = isDrawerOpen ? 0 : size.height * 0.1;
                      xOffset = isDrawerOpen ? 0 : size.width * 0.7;
                      scaleFactor = isDrawerOpen ? 1 : 0.8;
                      radius = isDrawerOpen ? 0 : 50;
                      isDrawerOpen = !isDrawerOpen;
                    });
                  },
                  icon: Icon(Icons.menu))
            ],
          ),
          TextButton(
            onPressed: () {
              gaodeGetLocation();
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => AmapApp()));
            },
            child: Text("获取天气"),
          ),
          // 天气、日期卡片
          Card(
            elevation: 7,
            margin: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Stack(
                children: [
                  // 天气背景
                  WeatherBg(
                    // weatherType: WeatherType.cloudy,
                    weatherType:
                        weatherBgMap[weatherInfo["lives"][0]["weather"]]!,
                    width: size.width * 0.9,
                    height: size.height * 0.3,
                  ),
                  // 日期与天气
                  Container(
                    // margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: size.width * 0.9,
                    height: size.height * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 日期列
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("你好！jealh", style: widget.dateTextStyle),
                            Text(
                              _time,
                              style: widget.dateTextStyle,
                            ),
                            Text(
                              _date,
                              style: widget.dateTextStyle,
                            ),
                          ],
                        ),
                        // 天气列
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                    text: weatherInfo["lives"][0]["province"],
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                TextSpan(
                                  text: "\n",
                                ),
                                TextSpan(
                                    text: weatherInfo['lives'][0]['city'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weatherInfo["lives"][0]["temperature"]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 36, color: Colors.white),
                                ),
                                Column(
                                  children: [
                                    Text("℃",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white))
                                  ],
                                )
                              ],
                            ),
                            Text(
                              weatherInfo["lives"][0]["weather"],
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // body部分
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 功能区
                  _buildFunItem("记笔记", size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunItem(String name, Size size) {
    return Container(
      height: size.height * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(crossAxisCount: 2, children: [
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purple.shade50, Colors.pink.shade50]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                // spreadRadius: 5,
                color: Colors.black45.withAlpha(30),
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/Notebook.png",
                width: 64,
                height: 64,
              ),
              Text(
                "记笔记",
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
