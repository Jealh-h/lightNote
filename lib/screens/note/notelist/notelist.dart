import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lightnote/constant.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/screens/note/write_note.dart/writenote.dart';
import 'package:lightnote/utils/http.dart';

class NoteList extends StatefulWidget {
  NoteList({Key? key, required this.notebookInfo}) : super(key: key);
  Map notebookInfo;
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List noteArr = [];
  bool loading = true;

  @override
  void initState() {
    getNoteList();
    super.initState();
  }

  void didChangeDependencies() {
    print("change");
  }

  getNoteList() async {
    setState(() {
      loading = true;
    });
    var result = await httpPost(uri: baseUrl + "/api/getnotelist", param: {
      "userid": "${widget.notebookInfo["userid"]}",
      "bid": "${widget.notebookInfo["bid"]}",
    });
    print(result);
    if (result["status"] == "success" && mounted) {
      setState(() {
        noteArr = result["data"];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        // title: Text("笔记本详情"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteNote(
                height: size.height,
                opr: "add",
                notebookInfo: widget.notebookInfo,
              ),
            ),
          ).then((value) async {
            if (value) {
              print(value);
              await getNoteList();
            }
          });
        },
        backgroundColor: IconColor,
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notebookInfo["name"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text("${widget.notebookInfo["time"]}")
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: size.width,
              height: size.height * 0.7,
              child: _buildBody(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (noteArr.length == 0) {
      return Center(
        // padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Image.asset(
              "assets/images/empty.png",
              height: 200,
              width: 200,
            ),
            Text(
              "暂无数据",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BaoTuXiaoBai'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
        itemCount: noteArr.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteNote(
                      height: MediaQuery.of(context).size.height,
                      notebookInfo: widget.notebookInfo,
                      opr: "modify",
                      noteInfo: noteArr[index],
                    ),
                  ),
                ).then((value) async {
                  if (value) {
                    getNoteList();
                  }
                });
              },
              isThreeLine: true,
              leading: Image.network(
                noteArr[index]["imageUrl"],
                width: 64,
                height: 64,
                fit: BoxFit.fill,
              ),
              minLeadingWidth: 64,
              // shape: Border(bottom: BorderSide()),
              title: Text("${noteArr[index]["title"]}"),
              subtitle: Text("${noteArr[index]["time"]}"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete_forever,
                onTap: () async {
                  EasyLoading.show();
                  var result =
                      await httpPost(uri: baseUrl + '/api/deletenote', param: {
                    "userid": "${noteArr[index]["userid"]}",
                    "bid": "${noteArr[index]["bid"]}",
                    "noteid": "${noteArr[index]["noteid"]}",
                  });
                  print(result);
                  EasyLoading.dismiss();
                  if (result["status"] == "success") {
                    setState(() {
                      noteArr = result["data"];
                    });
                  } else {
                    EasyLoading.showError(result["data"]);
                  }
                },
              )
            ],
            actionPane: SlidableScrollActionPane(),
          );
        });
  }
}
