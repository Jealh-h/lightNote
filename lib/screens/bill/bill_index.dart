import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/consumtion_type.dart';
import 'package:lightnote/components/date_picker.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/utils/http.dart';
import 'package:provider/provider.dart';
import 'package:lightnote/model/consumption.dart';
import 'package:lightnote/utils/utils.dart';

class BillIndex extends StatefulWidget {
  const BillIndex({Key? key}) : super(key: key);

  @override
  State createState() => BillIndexState();
}

class BillIndexState extends State<BillIndex> {
  final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      fontFamily: "TangYuan");
  final amountTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final typeTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  final TextStyle whiteText = TextStyle(color: Colors.white);

  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  bool loading = true;
  DateTime _time = DateTime.now();

  List billArr = [];
  int selectTypeIndex = 0;
  Map userInfo = {};
  Map cardData = {};

  @override
  void initState() {
    getUserInfo().then((value) => {
          setState(() {
            userInfo = value;
            updateDate();
          })
        });
  }

//  日期选择
  chooseDate() {
    showCupertinoModalPopup(
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: size.height * 0.55,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text("取消"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      child: Text("完成"),
                      onPressed: () {
                        setState(() {
                          _time;
                          updateDate();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Container(
                  height: size.height * 0.4,
                  child: CupertinoDatePicker(
                    initialDateTime: _time,
                    mode: CupertinoDatePickerMode.date,
                    maximumYear: DateTime.now().year,
                    minimumYear: DateTime.now().year - 2,
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime value) {
                      _time = value;
                    },
                  ),
                ),
              ],
            ),
          );
        },
        context: context);
  }

  // 根据时间更新面板
  updateDate() async {
    // 发送请求获取数据
    // setState设置数据更新内容
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    try {
      var result = await httpPost(uri: baseUrl + "/api/getbill", param: {
        "userid": userInfo["id"],
        "year": _time.year.toString(),
        "month": _time.month.toString(),
      });
      if (result["status"] == "success") {
        if (mounted) {
          setState(() {
            cardData["income"] = formmatedNum(result["income"].toString());
            cardData["count"] = result["count"].toString();
            cardData["expenditure"] =
                formmatedNum(result["expenditure"].toString());
            billArr = result["data"];
            loading = false;
          });
        }
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Container(
            // margin: EdgeInsets.only(top: 200),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 余额卡片
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      padding: EdgeInsets.symmetric(vertical: 25),
                      // alignment: Alignment.topLeft,
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff8B37DE),
                              Color(0xffCC55D4),
                              Color(0xffE067AE),
                              Color(0xffEC7585),
                              Color(0xffEE8680),
                              Color(0xffE6B898)
                            ]),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffE6B898),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                              spreadRadius: 0)
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "当月总支出:",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'TangYuan',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "¥",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "${cardData["expenditure"]}",
                                style: textStyle,
                              ),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "当前月总帐单数:${cardData["count"]}",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text.rich(TextSpan(children: [
                                TextSpan(text: "收入", style: whiteText),
                                TextSpan(
                                    text: "${cardData["income"]}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.amber.shade600)),
                                TextSpan(text: "元", style: whiteText),
                              ]))
                            ],
                          )
                        ],
                      ),
                    ),
                    // 日期选择
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "历史账单",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            chooseDate();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade200,
                            ),
                            height: 30,
                            // width: 100,
                            child: Row(
                              children: [
                                Text(_time.year.toString() +
                                    "年" +
                                    _time.month.toString() +
                                    "月"),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  color: Colors.grey.shade300,
                                  height: 20,
                                  width: 2,
                                ),
                                Icon(Icons.date_range)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 账单
                    Container(
                      width: double.infinity,
                      height: size.height * 0.5,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 30),
                        //  TODO 添加列表
                        children: _buildBillListPanel(),
                      ),
                    ),
                  ],
                ),
              ),
              // 记一笔按钮
              Positioned(
                width: size.width,
                bottom: 10,
                child: Center(
                  child: Container(
                    height: 40,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Color(0xffbfbfbf), blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _openAddBillPanel();
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.border_color,
                              color: Colors.green,
                            ),
                            Text(
                              "记一笔",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  void _openAddBillPanel() {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Color(0xff737373),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: _buildAddPanel(),
          ),
        );
      },
    );
  }

  Widget _buildAddPanel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 确认
            CupertinoButton(
              child: Text("确认"),
              onPressed: () async {
                int index = context.read<ComsumptionModel>().index;
                DateTime? time = context.read<ComsumptionModel>().time;
                var data = {
                  "userid": userInfo["id"],
                  "type": "$index",
                  "name": consumptionType[index]["name"],
                  "desc": "${remarkController.text}",
                  "year": "${time?.year.toString()}",
                  "month": "${time?.month.toString()}",
                  "day": "${time?.day.toString()}",
                  "time": DateTime.now().hour.toString() +
                      ':' +
                      DateTime.now().minute.toString(),
                  "value": "${amountController.text}"
                };
                if (amountController.text == "" ||
                    amountController.text == null) {
                  EasyLoading.showToast("请输入具体金额",
                      toastPosition: EasyLoadingToastPosition.center);
                } else {
                  var result = await httpPost(
                      uri: baseUrl + "/api/addbill", param: data);
                  // 添加成功
                  if (result["status"] == "success") {
                    EasyLoading.showSuccess(result["data"]);
                    Navigator.pop(context);
                  }
                  // 添加失败
                  else {
                    EasyLoading.showSuccess(result["data"]);
                  }
                }
              },
            ),
            // 取消
            CupertinoButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        TimePicker(),
        // 金额输入框
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Text(
                "¥",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                width: 300,
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              )
            ],
          ),
        ),
        // 类型框
        ConsumptionTypeScreen(),
        // 备注
        Row(
          children: [
            TextButton(
              onPressed: () {
                _showModalRemark();
              },
              child: Text(
                remarkController.text == '' ? "添加备注" : "修改",
                style: TextStyle(
                    color: Colors.grey.shade900, fontWeight: FontWeight.bold),
              ),
            ),
            Text(remarkController.text),
          ],
        )
      ],
    );
  }

  // 构建账单列表
  List<Widget> _buildBillListPanel() {
    if (billArr.length == 0) {
      return [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/images/empty.png",
              ),
              Text(
                "暂无数据",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BaoTuXiaoBai'),
              )
            ],
          ),
        )
      ];
    }
    // day : []
    return billArr.map((day) {
      return Card(
        elevation: 3.0,
        shadowColor: Colors.white54,
        margin: EdgeInsets.symmetric(vertical: 10),
        //设置shape，这里设置成了R角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
        clipBehavior: Clip.antiAlias,
        semanticContainer: false,
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day["day"],
                      style: typeTextStyle,
                    ),
                    Row(
                      children: [
                        Text("出：${formmatedNum(day["total-out"].toString())}"),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 20,
                          width: 2,
                          color: Colors.grey,
                        ),
                        Text("入：${formmatedNum(day["total-in"].toString())}")
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: day["data"].map<Widget>(
                  (data) {
                    return ListTile(
                      leading: Icon(
                          consumptionType[int.parse(data["type"])]["icon"]),
                      trailing: Text(
                        formmatedNum(data["value"]),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: double.parse(data["value"]) < 0
                                ? Colors.red
                                : Colors.amber),
                      ),
                      title: Text(
                        data["name"],
                        style: typeTextStyle,
                      ),
                      subtitle: Text(data["time"] + " | " + data["desc"]),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

// 备注框
  void _showModalRemark() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("添加备注"),
            content: Card(
                color: Colors.grey.shade300,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: remarkController,
                    maxLength: 30,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("确定")),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消"))
            ],
          );
        });
  }
}
