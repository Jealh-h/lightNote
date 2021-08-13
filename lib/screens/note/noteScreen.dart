import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightnote/components/circle_button.dart';
import 'package:lightnote/components/notebookCover_picker.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/screens/index/index.dart';

class NoteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteScreenState();
  }
}

class NoteScreenState extends State<NoteScreen> {
  var testArr;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initstate_note");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose_note");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: Center(
          child: Text("记笔记"),
        ),
        actions: [
          CircleButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              press: () {
                showAddNoteDialog("123", context, successBack: () {
                  print("object");
                });
              },
              backgroundColor: Colors.black)
        ],
        elevation: 0,
        backgroundColor: Color(0xfffff),
        leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: CircleButton(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              press: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Index()),
                );
              },
            )),
      ),
      body: Container(
        // color: Colors.black,
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }

  // 显示新增笔记本弹窗
  void showAddNoteDialog(String message, BuildContext context,
      {required Function successBack}) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '新建笔记本',
              style: TextStyle(
                  fontFamily: 'TangYuan', fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKey,
              child: Container(
                  height: 360,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 名称框
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: '请输入笔记本名称',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return '请输入笔记本名称';
                            }
                            return null;
                          },
                        ),
                        // 描述框
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: '请输入描述',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return '请输入描述';
                            }
                            return null;
                          },
                        ),
                        // 选择封面
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text("选择封面:"),
                        ),
                        NotebookCoverPicker()
                      ],
                    ),
                  )),
            ),
            actions: [
              CupertinoButton(
                child: Text("确定"),
                onPressed: () {
                  successBack();

                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // 验证正确
                  if (_formKey.currentState!.validate()) {
                    print(_formKey.currentState);
                    // Process data.
                  }
                  Navigator.pop(context);
                },
              ),
              CupertinoButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
