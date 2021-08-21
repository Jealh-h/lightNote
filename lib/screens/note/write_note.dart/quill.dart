// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as Quill;

// Quill.QuillController _controller = Quill.QuillController.basic();

// class QuillEditorCus extends StatefulWidget {
//   const QuillEditorCus({Key? key}) : super(key: key);

//   @override
//   _QuillEditorState createState() => _QuillEditorState();
// }

// class _QuillEditorState extends State<QuillEditorCus> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 30),
//             child: Quill.QuillToolbar.basic(controller: _controller),
//           ),
//           TextButton(
//             onPressed: () {
//               var json = jsonEncode(_controller.document.toDelta().toJson());
//               print(json);
//             },
//             child: Text("保存json"),
//           ),
//           Expanded(
//               child: Padding(
//             padding: EdgeInsets.all(9),
//             child: Container(
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(
//                     offset: Offset(5, 5),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                     color: Colors.lightBlueAccent),
//                 BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(0, 0),
//                     blurRadius: 0,
//                     spreadRadius: 0)
//               ]),
//               child: Quill.QuillEditor.basic(
//                 controller: _controller,
//                 readOnly: false, // true for view only mode
//               ),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
// }
