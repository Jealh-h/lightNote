import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/components/circle_button.dart';
import 'package:lightnote/components/circle_icon.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/screens/forgetPassword/ForgetPassWord.dart';
import 'package:lightnote/screens/index/index.dart';
import 'package:lightnote/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Map userInfo = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo().then((value) => {
          setState(() {
            userInfo = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 40,
          leading: CircleButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              press: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Index()),
                );
              },
              backgroundColor: Colors.transparent)),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 0,
              child: Container(
                // margin: ,
                width: size.width,
                // color: Colors.red,
                child: Stack(
                  children: [
                    // 头像
                    Positioned(
                      width: size.width,
                      top: size.width / 1.2 * 0.1,
                      child: Column(
                        children: [
                          // 头像
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(64),
                                border:
                                    Border.all(width: 5, color: Colors.blue)),
                            child: ClipOval(
                              child: userInfo["id"] == null
                                  ? Image.network(
                                      defaultAvatarUrl,
                                      width: 64,
                                      height: 64,
                                    )
                                  : Image.network(
                                      userInfo["avatarUrl"],
                                      width: 64,
                                      height: 64,
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            userInfo["username"] == null
                                ? ""
                                : userInfo["username"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                                color: Colors.black),
                          ),
                          Text("这是一个字符串"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 350,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: CircleIcon(
                        color: Color(0xffA279D7),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("编辑资料"),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: CircleIcon(
                        color: Color(0xffA279D7),
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      onTap: showImgSelectModal,
                      title: Text("更改头像"),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: CircleIcon(
                        color: Color(0xffA279D7),
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassWord()));
                      },
                      title: Text("修改密码"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              getUserInfo().then((value) => print(value));
            },
            child: Text("sf"),
          ),
        ],
      ),
    );
  }

// 显示底部图片选择框
  void showImgSelectModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 180,
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Column(
            children: [
              CupertinoButton(child: Text("相机"), onPressed: selectImgByCamera),
              CupertinoButton(child: Text("图库"), onPressed: selectImgByGallery),
            ],
          ),
        );
      },
    );
  }

// 从相机获取图片
  void selectImgByCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print(await image?.length());
  }

  // 从图库获取图片
  void selectImgByGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }
}
