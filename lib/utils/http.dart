import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/constants/const.dart';
import 'package:lightnote/utils/utils.dart';

httpGet(String authority, String unencodedPath,
    [Map<String, dynamic>? queryParameters]) async {
  var url = Uri.http(authority, unencodedPath, queryParameters);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    // var jsonResponse =
    //     convert.jsonDecode(response.body) as Map<String, dynamic>;
    print(response.body);
    return response.body;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

httpsGet(String authority, String unencodedPath,
    [Map<String, dynamic>? queryParameters]) async {
  var url = Uri.https(authority, unencodedPath, queryParameters);
  print("url:$url");
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

httpPost({Map<String, dynamic>? param, required String uri}) async {
  try {
    var url = Uri.parse(uri);
    var response = await http.post(url, body: param);
    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  } catch (e) {
    print(e);
  }
}

// 通过选择好的--文件--头像上传
dioUploadFile(XFile f, Map userInfo) async {
  var dio = Dio();
  String path = f.path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
  var formData = new FormData.fromMap({
    "userid": "${userInfo["id"]}",
    "file": await MultipartFile.fromFile(path, filename: name)
  });
  try {
    var response =
        await dio.post<String>(baseUrl + '/api/upload', data: formData);
    return convert.jsonDecode(response.toString()) as Map<String, dynamic>;
  } catch (e) {
    print(e);
  }
}

// 以字节流上传文件--笔记
dioUploadFileByByte(List<int> bytes, Map info) async {
  var dio = Dio();
  // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
  var formData = new FormData.fromMap({
    ...info,
    "file": MultipartFile.fromBytes(bytes,
        filename: "${info["bid"]}-${getRandId()}.jpg")
  });
  try {
    var response =
        await dio.post<String>(baseUrl + '/api/addnote', data: formData);
    return convert.jsonDecode(response.toString()) as Map<String, dynamic>;
  } catch (e) {
    print(e);
  }
}
