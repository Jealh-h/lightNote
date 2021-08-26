import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/model/cover.dart';
import 'package:lightnote/model/emailUrl.dart';
import 'package:lightnote/model/user.dart';
import 'package:lightnote/model/uuid.dart';
import 'package:lightnote/screens/index/index.dart';
import 'package:lightnote/screens/login/login.dart';
import 'package:lightnote/screens/note/noteScreen.dart';
import 'package:lightnote/utils/utils.dart';
import 'package:provider/provider.dart';

import 'model/consumption.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => EmailModel()),
        ChangeNotifierProvider(create: (BuildContext context) => UUidModel()),
        ChangeNotifierProvider(create: (BuildContext context) => UserModel()),
        ChangeNotifierProvider(create: (BuildContext context) => CoverModel()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ComsumptionModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/note": (context) => NoteScreen()},
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.indigo[50]),
      home: MyHomePage(title: 'lightNote'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  Map userInfo = {};
  @override
  void initState() {
    super.initState();
    // 添加提示框监听
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getUserInfo().then((Map userinfo) {
      // context.read<UserModel>().setUserInfo(userinfo);
      setState(() {
        userInfo = userinfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: userInfo["id"] == null ? LoginScreen() : Index(),
      ),
      // child: Test(),
    );
  }
}
