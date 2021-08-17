import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BillIndex extends StatefulWidget {
  const BillIndex({Key? key}) : super(key: key);

  @override
  State createState() => BillIndexState();
}

class BillIndexState extends State<BillIndex> {
  final textStyle = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "TangYuan");
  final amountTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final typeTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 余额卡片
              Container(
                margin: EdgeInsets.only(bottom: 30),
                padding: EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.amber.shade800,
                        offset: Offset(0, 5),
                        blurRadius: 5,
                        spreadRadius: 0)
                  ],
                  gradient: LinearGradient(
                      colors: [Colors.amber, Colors.pink.shade400]),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "当前余额:",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'TangYuan',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: "¥",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "18.00",
                          style: textStyle,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Text(
                "历史账单-1234567890",
                style: textStyle,
              ),
              // 账单
              Container(
                width: double.infinity,
                height: size.height * 0.5,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  padding: EdgeInsets.only(bottom: 30),
                  children: [
                    Card(
                      //z轴的高度，设置card的阴影
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
                        // color: Colors.deepPurpleAccent,
                        width: double.infinity,
                        // height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              color: Colors.grey.shade100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "8月15日",
                                    style: typeTextStyle,
                                  ),
                                  Text("支出20.00"),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.traffic),
                              trailing: Text(
                                "-20.00",
                                style: amountTextStyle,
                              ),
                              title: Text(
                                "交通",
                                style: typeTextStyle,
                              ),
                              subtitle: Text("19:20 公交车"),
                            ),
                            ListTile(
                              leading: Icon(Icons.traffic),
                              trailing: Text(
                                "-20.00",
                                style: amountTextStyle,
                              ),
                              title: Text(
                                "交通",
                                style: typeTextStyle,
                              ),
                              subtitle: Text("19:20 公交车"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      //z轴的高度，设置card的阴影
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
                        // color: Colors.deepPurpleAccent,
                        width: double.infinity,
                        // height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              color: Colors.grey.shade100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "8月15日",
                                    style: typeTextStyle,
                                  ),
                                  Text("支出20.00"),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.traffic),
                              trailing: Text(
                                "-20.00",
                                style: amountTextStyle,
                              ),
                              title: Text(
                                "交通",
                                style: typeTextStyle,
                              ),
                              subtitle: Text("19:20 公交车"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                boxShadow: [BoxShadow(color: Color(0xffbfbfbf), blurRadius: 5)],
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
                            color: Colors.green, fontWeight: FontWeight.bold),
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
            CupertinoButton(
              child: Text("确认"),
              onPressed: () {},
            ),
            CupertinoButton(
              child: Text("取消"),
              onPressed: () {},
            ),
          ],
        ),
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
                  decoration: InputDecoration(border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              )
            ],
          ),
        ),
        // 类型框
        Container(
          width: double.infinity,
          height: 90,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: GridView.count(
            crossAxisCount: 4,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.local_mall),
                  ),
                  Text("服饰")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    color: Colors.green,
                    onPressed: () {},
                    icon: Icon(Icons.fastfood),
                  ),
                  Text("餐饮")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.directions_car),
                  ),
                  Text("交通")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.error_outline),
                  ),
                  Text("其他")
                ],
              ),
            ],
          ),
        ),
        // 备注
        Row(
          children: [
            TextButton(
                onPressed: () {
                  _showModalRemark();
                },
                child: Text(
                  "添加备注",
                  style: TextStyle(
                      color: Colors.grey.shade900, fontWeight: FontWeight.bold),
                ))
          ],
        )
      ],
    );
  }

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
                    maxLength: 30,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )),
            actions: [
              CupertinoDialogAction(child: Text("确定")),
              CupertinoDialogAction(child: Text("取消"))
            ],
          );
        });
  }
}
