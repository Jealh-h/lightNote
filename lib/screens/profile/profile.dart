import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/components/circle_button.dart';
import 'package:lightnote/screens/index/index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

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
            aspectRatio: 1.2,
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 5,
              child: Container(
                // margin: ,
                width: size.width,
                // color: Colors.red,
                child: Stack(
                  children: [
                    // 头像
                    Positioned(
                      width: size.width,
                      top: size.width / 1.2 * 0.25,
                      // left: size.width / 1.2 * 0.5,
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
                              child: Image.asset(
                                "assets/images/avatar.png",
                                width: 64,
                                height: 64,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Jealh",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 36),
                          ),
                          Text("这是一个签名"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: showImgSelectModal,
            child: Text("选择文件"),
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
