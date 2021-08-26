import 'package:flutter/material.dart';
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
    var result = await httpPost(uri: baseUrl + "/api/getnotelist", param: {
      "userid": "${widget.notebookInfo["userid"]}",
      "bid": "${widget.notebookInfo["bid"]}",
    });
    setState(() {
      noteArr = result["data"];
      loading = false;
    });
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
                notebookInfo: widget.notebookInfo,
              ),
            ),
          );
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
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WriteNote(
                            height: MediaQuery.of(context).size.height,
                            notebookInfo: widget.notebookInfo,
                            noteInfo: noteArr[index],
                          )));
            },
            isThreeLine: true,
            leading: Image.network(
              noteArr[index]["imageUrl"],
              width: 64,
              height: 64,
              fit: BoxFit.fill,
            ),
            // shape: Border(bottom: BorderSide()),
            title: Text("${noteArr[index]["title"]}"),
            subtitle: Text("${noteArr[index]["time"]}"),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        });
  }
}
