import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/circle_button.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';
import 'package:lightnote/components/tail_input_container.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/model/emailUrl.dart';
import 'package:lightnote/model/uuid.dart';
import 'package:lightnote/screens/index/index.dart';
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';
import 'package:provider/provider.dart';

class ForgetPassWord extends StatefulWidget {
  ForgetPassWord({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ForgetPassWordState();
  }
}

class ForgetPassWordState extends State<ForgetPassWord> {
  int currentStep = 1;
  List<Widget> panels = [];
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  Map _result = {};
  int remainTime = 60;
  bool isTouched = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    isTouched = false;
    _timer?.cancel();
    _timer = null;
    _result = {};
    Future.delayed(Duration.zero, () {
      setState(() {
        panels = [
          buildVerifyEmail(),
          RetrieveResult(),
        ];
        currentStep = 1;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 构建指示器
  Widget buildIndicator(String text, int index) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                currentStep == index ? Colors.amber[900] : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Text(
            "$index",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Text("$text"),
      ],
    );
  }

  // 验证邮箱页面
  Widget buildVerifyEmail() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InputContainer(
          controller: passController,
          icon: Icons.vpn_key,
          hintText: "请输入新密码",
          onChanged: (string) {},
        ),
        TailInputContainer(
          controller: confirmController,
          icon: Icons.vpn_key,
          hintText: "请确认新密码",
          onChanged: (string) {},
        ),
        // 邮箱输入框
        InputContainer(
          controller: mailController,
          icon: Icons.email,
          hintText: "请输入邮箱地址",
          onChanged: (string) {
            context.read<EmailModel>().setEmail(string);
          },
        ),
        // 验证码
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: size.width * 0.8,
          child: Row(
            children: [
              Container(
                width: 200,
                height: 50,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          color: Color(0xFFD3D3D3).withOpacity(0.84)),
                    ]),
                child: TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                      hintText: "请输入验证码", border: InputBorder.none),
                ),
              ),
              Spacer(),
              // 获取验证码
              GestureDetector(
                onTap: () {
                  handleEnableTouch();
                },
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      color:
                          isTouched ? Colors.grey.shade400 : Colors.amber[900],
                      borderRadius: BorderRadius.circular(5)),
                  alignment: Alignment.center,
                  child: Text("${isTouched ? '${remainTime}s' : '获取验证码'}"),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.1,
        ),
      ],
    );
  }

  // 找回结果
  Widget RetrieveResult() {
    Size size = MediaQuery.of(context).size;
    return _result["status"] == "success"
        ? Column(
            children: [
              Image.asset(
                "assets/images/success.png",
                width: 128,
                height: 128,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("${_result["data"]}"),
              ),
            ],
          )
        : Column(
            children: [
              Image.asset(
                "assets/images/fail.png",
                width: 128,
                height: 128,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("${_result["data"]}"),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
              },
              backgroundColor: Colors.transparent)),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 进度条
              Container(
                width: size.width * 0.8,
                child: Row(
                  children: [
                    buildIndicator("修改新密码", 1),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    buildIndicator("找回结果", 2)
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.15,
              ),

              // 当前步骤页面
              panels.length == 0 ? Text("loading") : panels[currentStep - 1],
              // 下一步
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: size.width * 0.8,
                child: PrimaryButton(
                  color: Colors.amber[900],
                  text: currentStep == 2 ? "完成" : "下一步",
                  press: () {
                    handleNextStep();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleNextStep() async {
    switch (currentStep) {
      case 1:
        {
          String password = passController.text;
          String confirmPass = confirmController.text;
          if (codeController.text.isEmpty ||
              password.isEmpty ||
              confirmPass.isEmpty ||
              mailController.text.isEmpty) {
            EasyLoading.showInfo("请验证信息完整");
          } else if (password != confirmPass) {
            EasyLoading.showError("请确认密码一致");
          } else if (!matchEmail(mailController.text)) {
            EasyLoading.showError("请确认邮箱格式");
          } else {
            EasyLoading.show(status: "校验中");
            var result =
                await httpPost(uri: baseUrl + "/api/modifypassword", param: {
              "password": password,
              "email": mailController.text,
              "uuid": context.read<UUidModel>().uuid,
              "Vcode": codeController.text
            });
            print(result);
            if (result["status"] == "success") {
              EasyLoading.dismiss();
              print(result);
              // 验证成功后清空uuid
              context.read<UUidModel>().setUUid("");
              setState(() {
                _result = result;
                currentStep = currentStep + 1;
                panels = [
                  buildVerifyEmail(),
                  RetrieveResult(),
                ];
              });
            } else {
              EasyLoading.showInfo(result["data"]);
            }
          }
        }
        break;
      case 2:
        {
          Navigator.pop(context);
        }
        break;
      default:
        break;
    }
  }

  // 发送邮件
  sendEmail() async {
    var result = await httpPost(
        uri: baseUrl + "/api/sendcode",
        param: {"email": context.read<EmailModel>().email});
    print("res:$result");
    if (result["status"] == "success") {
      print(result["data"]["uuid"]);
      // 获取成功设置uuid
      context.read<UUidModel>().setUUid(result["data"]["uuid"]);
      context.read<EmailModel>().setEmail("");
      EasyLoading.showSuccess("发送成功，请注意查收邮件");
    }
  }

  handleEnableTouch() {
    if (!matchEmail(context.read<EmailModel>().email)) {
      EasyLoading.showInfo("请输入正确邮件信息");
      return;
    } else {
      if (!isTouched) {
        isTouched = true;
        // 启动定时器
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (remainTime < 1 || currentStep == 2) {
            timer.cancel();
            isTouched = false;
            remainTime = 60;
          }
          print(remainTime);
          if (mounted) {
            setState(() {
              remainTime = remainTime - 1;
              panels = [
                buildVerifyEmail(),
                RetrieveResult(),
              ];
            });
          }
        });
        sendEmail();
      } else {
        return;
      }
    }
  }
}

// 按钮样式
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.transparent,
  // minimumSize: Size(30, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);
