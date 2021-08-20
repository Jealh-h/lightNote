import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/utils/http.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          selectImgByCamera();
        },
        child: Text("打开相机"),
      ),
    );
  }

  // 从相机获取图片
  void selectImgByCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    // print(await image?.mimeType);
    // print(await image?.name);
    // print(await image?.path);
    // print(await image?.runtimeType);
    if (image != null) {
      print(image.name);
      print(image.path);
      dioUploadFile(image);
    }

    // print(await image?.);
  }
}
