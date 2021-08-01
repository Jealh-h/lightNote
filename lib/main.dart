import 'package:flutter/material.dart';
import 'package:lightnote/screens/login/login.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.indigo[50]),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DefaultPadding),
            child: Column(children: [
              Spacer(flex: 3),
              PrimaryButton(
                text: "登录",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              PrimaryButton(
                text: "注册",
                color: Colors.orange[300],
                press: () {},
              ),
              Container(
                margin: EdgeInsets.only(top: DefaultPadding),
                padding: EdgeInsets.only(
                    left: DefaultPadding, right: DefaultPadding),
                child: Row(
                  children: [
                    Text("忘记密码", style: TextStyle(color: Colors.blue)),
                    Spacer(),
                    Text("游客登陆", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
