import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/model/user.dart';
import 'package:lightnote/screens/about/about.dart';
import 'package:lightnote/screens/profile/profile.dart';
import 'package:lightnote/utils/utils.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerScreenState();
  }
}

class DrawerScreenState extends State<DrawerScreen> {
  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 16);
  Map userInfo = {};
  @override
  initState() {
    super.initState();
    getUserInfo().then((value) => {
          setState(() {
            userInfo = value;
          })
        });
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.only(top: 50, bottom: 50, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 头像、签名、姓名
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: ClipOval(
                    child: userInfo["id"] == null
                        ? Image.network(
                            defaultAvatarUrl,
                            width: 56,
                            height: 56,
                          )
                        : Image.network(
                            userInfo["avatarUrl"],
                            width: 56,
                            height: 56,
                          ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo["username"] == null ? "" : userInfo["username"],
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      "${userInfo["signature"]}",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white54),
                    )
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  TextButton(
                      onPressed: () async {
                        var dio = Dio();
                        var res = await dio.get(
                            "https://120.77.134.169:443/v3/weather/weatherInfo?key=25d3dafaaf101d84a39d5670e2d74d2f&city=110101");
                        print(res);
                      },
                      child: Text(
                        "意见反馈",
                        style: textStyle,
                      )),
                ],
              ),
              // 关于
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutScreen()));
                      },
                      child: Text(
                        "关于我们",
                        style: textStyle,
                      )),
                ],
              ),
            ],
          ),
          // 退出登录
          Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.white,
              ),
              // 退出登录
              TextButton(
                onPressed: () {
                  signOut(context);
                },
                child: Text(
                  "退出登录",
                  style: textStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
