import 'package:flutter/material.dart';
import 'package:lightnote/components/input_container.dart';
import 'package:lightnote/components/primary_button.dart';
import 'package:lightnote/components/tail_input_container.dart';

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
                    text: "注 册",
                    press: () async {},
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
}
