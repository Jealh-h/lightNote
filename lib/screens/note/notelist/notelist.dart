import 'package:flutter/material.dart';
import 'package:lightnote/screens/note/write_note.dart/quill.dart';
import 'package:lightnote/screens/note/write_note.dart/writenote.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("123"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => WriteNote(
              //               height: MediaQuery.of(context).size.height,
              //             )));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => QuillEditorCus(),
              //   ),
              // );
            },
            leading: Icon(Icons.note),
            title: Text("123"),
          )
        ],
      ),
    );
  }
}
