import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/model/emailUrl.dart';
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';
import 'package:provider/provider.dart';

class VerifyCodeButton extends StatefulWidget {
  const VerifyCodeButton({Key? key}) : super(key: key);

  @override
  _VerifyCodeButtonState createState() => _VerifyCodeButtonState();
}

class _VerifyCodeButtonState extends State<VerifyCodeButton> {
  int remainTime = 60;
  bool isTouched = false;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remainTime = 60;
    isTouched = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: handleEnableTouch(),
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                color: isTouched ? Colors.grey.shade400 : Colors.amber[900],
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text("${isTouched ? '${remainTime}s' : '获取验证码'}"),
          ),
        ),
      ],
    );
  }

  sendEmail() async {
    if (matchEmail(context.read<EmailModel>().email)) {
      await httpPost(
          uri: baseUrl + "/api/ssendcode",
          param: {"eamil": context.read<EmailModel>().email});
      EasyLoading.showSuccess("发送成功，请注意查收邮件");
    } else {
      EasyLoading.showInfo("请输入正确邮件信息");
    }
  }

  handleEnableTouch() {
    // 获取验证码后，重置状态
    if (isTouched) {
      // 发送验证码
      sendEmail();
      return null;
    } else {
      return () {
        if (mounted) {
          setState(
            () {
              // 设置时间
              remainTime = 60;
              isTouched = true;
            },
          );
          _timer = Timer.periodic(
            Duration(seconds: 1),
            (timer) {
              if (remainTime < 1) {
                if (mounted) {
                  setState(() {
                    isTouched = false;
                  });
                }
                _timer?.cancel();
                _timer = null;
              } else {
                if (mounted) {
                  setState(() {
                    remainTime = remainTime - 1;
                  });
                }
              }
            },
          );
        }
      };
    }
  }
}
