import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerScreenState();
  }
}

class DrawerScreenState extends State<DrawerScreen> {
  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 16);

  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.only(top: 50, bottom: 50, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 头像、签名、姓名
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/avatar.png",
                    height: 56,
                    width: 56,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jealh",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Text(
                    "this is my flutter app",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54),
                  )
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                  Text(
                    " 我的工作空间",
                    style: textStyle,
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              Text(
                "设置",
                style: textStyle,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 20,
                width: 5,
                color: Colors.white,
              ),
              Icon(
                Icons.logout,
                color: Colors.white,
              ),
              Text(
                "退出登录",
                style: textStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}
