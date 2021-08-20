import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightnote/screens/index/index.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          Image.asset(
            "assets/images/ic_logo.png",
            width: 100,
            height: 100,
          ),
          // version
          Text(
            "lightNote",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "BaoTuXiaoBai"),
          ),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: "V",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextSpan(
              text: "1.0.1",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ])),
          // author
          Text(
            "作者：Jealh",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "TangYuan"),
          ),
          //  qq
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/QQ.png",
                width: 32,
                height: 32,
              ),
              Text(
                "1620175472",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TangYuan"),
              ),
            ],
          ),
          // github
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/GitHub.png",
                width: 30,
                height: 30,
              ),
              Text(
                "https://github.com/Jealh-h",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TangYuan"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: CupertinoButton.filled(
                child: Text("返 回"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Index()));
                }),
          )
        ],
      ),
    );
  }
}
