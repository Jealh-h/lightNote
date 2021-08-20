import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';
import 'package:lightnote/components/tail_input_container.dart';
import 'package:lightnote/constant.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/screens/Signup/signup.dart';
import 'package:lightnote/screens/forgetPassword/ForgetPassWord.dart';
import 'package:lightnote/screens/index/index.dart';
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  Timer? _timer;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _enablePress = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
          children: <Widget>[
            Positioned(
              left: 0,
              top: 10,
              child: Image.asset(
                'assets/images/index.png',
                // fit: BoxFit.cover,
                height: size.height,
                // width: size.width,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  InputContainer(
                    controller: username,
                    hintText: "请输入账户名",
                    onChanged: (string) {
                      _setBtnState();
                    },
                  ),
                  TailInputContainer(
                    controller: password,
                    hintText: "请输入账户密码",
                    onChanged: (string) {
                      _setBtnState();
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: PrimaryButton(
                      color: IconColor,
                      text: "登 录",
                      press: _handleLoginBtn(),
                    ),
                  ),
                  // 没有账号,忘记密码
                  Container(
                    width: size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPassWord(),
                              ),
                            );
                          },
                          child: Text(
                            "忘记密码？",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Text("还没有账号？"),
                        GestureDetector(
                          child: Text(
                            "注册",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // 其他方式
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: InputColor,
                            height: 1.5,
                          ),
                        ),
                        Text("其他方式"),
                        Expanded(
                          child: Divider(
                            color: InputColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // qq OR wechat
                  Container(
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/images/QQ.png",
                            width: 36,
                            height: 36,
                          ),
                        ),
                        SizedBox(
                          width: 36,
                        ),
                        Container(
                          child: Image.asset(
                            "assets/images/wx.png",
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showToast() async {
    await EasyLoading.show(
      status: '登录中...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  Future<void> hiddenToast() async {
    _timer?.cancel();
    await EasyLoading.dismiss();
  }

  // 登录按钮事件
  _handleLoginBtn() {
    // 返回 null 代表 按钮不可用
    if (!_enablePress) return null;
    return () async {
      // 记录账号与密码到内存
      // final SharedPreferences prefs = await _prefs;
      // prefs.setString(Constant.userAccount, _username);
      // prefs.setString(Constant.userPassword, _password);
      // 跳转页面

      // httpGet("10.0.2.2:7001", "/");
      showToast();
      var result = await httpPost(param: {
        "username": "${username.text}",
        "password": "${password.text}"
      }, uri: baseUrl + "/api/signin");
      hiddenToast();
      // EasyLoading.dismiss();
      if (result["status"] == 'success') {
        // 提示登录成功
        EasyLoading.showSuccess('登录成功');
        setUserInfo(result["data"]);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Index()));
      } else {
        // 提示错误信息
        EasyLoading.showToast(result["data"],
            toastPosition: EasyLoadingToastPosition.top);
      }
    };
  }

  // textfield的onchange事件，用于确定登录按钮是否可用
  void _setBtnState() {
    // 账户输入与密码输入框都不为空时，登录按钮才可用
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      if (_enablePress) return;
    } else {
      if (!_enablePress) return;
    }
    setState(() {
      _enablePress = !_enablePress;
    });
  }
}
