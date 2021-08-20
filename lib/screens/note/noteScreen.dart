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
  final List _noteBookArr = [
    {
      "name": "记flutter笔记的",
      "cover": "assets/images/notebook_cover1.png",
      "desc": "这是描述信息",
      "time": "2021/8/18 20:56"
    },
    {
      "name": "记flutter笔记的",
      "cover": "assets/images/notebook_cover2.png",
      "desc": "这是描述信息",
      "time": "2021/8/18 20:56"
    },
    {
      "name": "记flutter笔记的555555555555",
      "cover": "assets/images/notebook_cover3.png",
      "desc": "这是描述信息",
      "time": "2021/8/18 20:56"
    },
    {
      "name": "记flutter笔记的555555555555",
      "cover": "assets/images/notebook_cover1.png",
      "desc": "这是描述信息",
      "time": "2021/8/18 20:56"
    },
    {
      "name": "记flutter笔记的",
      "cover": "assets/images/notebook_cover7.png",
      "desc": "这是描述信息",
      "time": "2021/8/18 20:56"
    },
  ];
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
        child: SingleChildScrollView(
          child: buildNotePage(size),
        ),
      ),
    );
  }

  Widget buildNotePage(Size size) {
    if (_noteBookArr.length == 0) {
      return Center(
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
      );
    }
    return Container(
      width: size.width,
      height: size.height * 0.84,
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          padding: EdgeInsets.symmetric(vertical: 10),
          children: _noteBookArr
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Colors.grey.shade200)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Image.asset(
                            "${e["cover"]}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 笔记本标题，描述信息，日期
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e["name"]}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${e["desc"]}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '${e["time"]}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            // 子菜单
                            PopupMenuButton(
                              onSelected: (value) {
                                print(value);
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: {
                                      ...e,
                                      ...{"opr": "edit"}
                                    }, //点击后回调函数的参数
                                    height: 20,
                                    child: Text("编辑"),
                                  ),
                                  PopupMenuItem(
                                    height: 2,
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: {
                                      ...e,
                                      ...{"opr": "delete"}
                                    }, //点击后回调函数的参数
                                    height: 20,
                                    child: Text("删除"),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
              .toList()),
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
