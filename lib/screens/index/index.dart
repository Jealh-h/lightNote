import 'package:flutter/material.dart';
import 'package:lightnote/components/drawer.dart';
import 'package:lightnote/components/index_home.dart';
import 'package:lightnote/screens/profille/profile.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexStateScreen();
  }
}

class IndexStateScreen extends State<Index> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.black87,
      body: Stack(
        children: [
          DrawerScreen(),
          IndexHome(),
        ],
      ),
    );
  }
}
