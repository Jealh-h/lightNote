import 'package:flutter/material.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';

class ForgetPassWord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgetPassWordState();
  }
}

class ForgetPassWordState extends State<ForgetPassWord> {
  int currentStep = 1;
  List<Widget> panels = [];
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      panels = [
        buildVerifyEmail(),
        buildModifyPassWord(),
        RetrieveResult(),
      ];
      setState(() {
        panels;
        currentStep = 1;
      });
    });
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
        // 邮箱输入框
        InputContainer(
          controller: mailController,
          icon: Icons.email,
          hintText: "请输入邮箱地址",
          onChanged: (string) {},
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
                  decoration: InputDecoration(
                      hintText: "请输入验证码", border: InputBorder.none),
                ),
              ),
              Spacer(),
              // 获取验证码
              Container(
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Text("获取验证码"),
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

  // 修改新密码
  Widget buildModifyPassWord() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InputContainer(
          controller: passController,
          icon: Icons.vpn_key,
          hintText: "请输入新密码",
          onChanged: (string) {},
        ),
        InputContainer(
          controller: confirmController,
          icon: Icons.vpn_key,
          hintText: "请确认新密码",
          onChanged: (string) {},
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
    return Column(
      children: [
        Image.asset(
          "assets/images/success.png",
          width: 128,
          height: 128,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("找回成功，确认登录"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              // 进度条
              Container(
                width: size.width * 0.8,
                child: Row(
                  children: [
                    buildIndicator("确认邮箱", 1),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    buildIndicator("修改新密码", 2),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    buildIndicator("找回结果", 3)
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
                  text: currentStep == 3 ? "完成" : "下一步",
                  press: () {
                    if (currentStep < 3) {
                      setState(() {
                        currentStep++;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
