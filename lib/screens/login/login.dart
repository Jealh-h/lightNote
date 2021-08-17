import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';
import 'package:lightnote/components/tail_input_container.dart';
import 'package:lightnote/constant.dart';
import 'package:lightnote/screens/Signup/signup.dart';
import 'package:lightnote/screens/forgetPassword/ForgetPassWord.dart';
import 'package:lightnote/screens/index/index.dart';
import 'package:lightnote/utils/http.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                    onChanged: (string) {},
                  ),
                  TailInputContainer(
                    controller: password,
                    hintText: "请输入账户密码",
                    onChanged: (string) {},
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: PrimaryButton(
                      color: IconColor,
                      text: "登 录",
                      press: () async {
                        // httpGet("10.0.2.2:7001", "/");
                        var result = await httpPost(param: {
                          "username": "${username.text}",
                          "password": "${password.text}"
                        }, uri: "http://10.0.2.2:7001/api/signin");
                        if (result["status"] == 'success') {
                          // 提示登录成功
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Index()));
                        } else {
                          // 提示错误信息
                          // Fluttertoast.showToast(
                          //   gravity: ToastGravity.CENTER,
                          //   backgroundColor: Colors.amber[900],
                          //   msg: result['data'],
                          // );
                          showToast();
                        }
                      },
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

  void showToast() {
    Fluttertoast.showToast(gravity: ToastGravity.CENTER, msg: "123");
  }
}
