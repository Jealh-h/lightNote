import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';
import 'package:lightnote/components/tail_input_container.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';

import '../../constant.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                // welcome
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: "Welcome\n",
                          style: TextStyle(
                              fontSize: 36,
                              fontFamily: "TangYuan",
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: "LightNote",
                        style: TextStyle(
                            fontFamily: "BaoTuXiaoBai",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                // username
                InputContainer(
                  controller: username,
                  hintText: "请输入账户名",
                  onChanged: (string) {},
                ),
                // password
                TailInputContainer(
                  controller: password,
                  hintText: "请输入账户密码",
                  onChanged: (string) {},
                ),
                // email
                InputContainer(
                  icon: Icons.email,
                  controller: email,
                  hintText: "请输入邮箱地址",
                  onChanged: (string) {},
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  child: PrimaryButton(
                    color: IconColor,
                    text: "注 册",
                    press: () {
                      handleSignUp();
                    },
                  ),
                ),
                Row(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Text("已有账号?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("登录"),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleSignUp() async {
    if (username.text == "" || password.text == "" || email.text == "") {
      // 存在空值
      EasyLoading.showInfo("请输入完整信息");
      return;
    } else if (!matchEmail(email.text)) {
      EasyLoading.showError("请输入正确邮件信息");
      return;
    } else {
      EasyLoading.show();
      var res = await httpPost(uri: baseUrl + "/api/signup", param: {
        "email": email.text,
        "username": username.text,
        "password": password.text
      });
      EasyLoading.dismiss();
      if (res['status'] == "fail") {
        EasyLoading.showError(res["data"]);
      } else {
        setState(() {
          username.text = '';
          password.text = '';
          email.text = '';
        });
        EasyLoading.showSuccess(res["data"]);
      }
      return;
    }
  }
}
