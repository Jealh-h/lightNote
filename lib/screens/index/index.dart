import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightnote/components/drawer.dart';
import 'package:lightnote/components/index_home.dart';
import 'package:lightnote/screens/note/noteScreen.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexStateScreen();
  }
}

class IndexStateScreen extends State<Index> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate_index");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose_index");
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    print('返回NewView');
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    print('进入NewView');
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          IndexHome(),
        ],
      ),
    );
  }
}
