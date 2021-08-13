import 'package:flutter/material.dart';
import 'package:lightnote/constants/const.dart';

class NotebookCoverPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotebookCoverPickerState();
  }
}

class NotebookCoverPickerState extends State<NotebookCoverPicker> {
  String selectedNotebooCover = "";
  List<Widget>? NotebookCovers;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 280,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: noteBookCover.map((e) {
          var color =
              selectedNotebooCover == e ? Colors.blue[200] : Colors.white;
          return GestureDetector(
            onTap: () {
              setSelectedNotebookCover(e);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(5)),
              child: Image.asset(
                e,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 给当前选择的封面设置边框
  void setSelectedNotebookCover(String cover) {
    // 设置当前选中的笔记本封面

    // 返回新的封面数组
    NotebookCovers = noteBookCover.map((e) {
      var color = cover == e ? Colors.blue[200] : Colors.white;
      return GestureDetector(
        onTap: () {
          setSelectedNotebookCover(e);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5)),
          child: Image.asset(
            e,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
    setState(() {
      NotebookCovers;
      selectedNotebooCover = cover;
    });
  }
}
