import 'package:flutter/material.dart';
import 'package:lightnote/screens/login/login.dart';
import 'package:lightnote/screens/note/noteScreen.dart';
import 'package:lightnote/screens/test/test.dart';

import 'components/primary_button.dart';
import 'constant.dart';

void main() {
  runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        // child: LoginScreen(),
        child: Test(),
      ),
    );
  }
}
