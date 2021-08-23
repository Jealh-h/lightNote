import 'dart:convert' as convert;
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/constants/const.dart';

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

dioUploadFile(XFile f) async {
  var dio = Dio();
  String path = f.path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  // var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
  var formData = new FormData.fromMap({
    "userId": "1000024",
    "file": await MultipartFile.fromFile(path, filename: name)
  });
  try {
    var response = await dio.post(baseUrl + '/api/upload', data: formData);
    print(response);
    // var response = await dio.post(baseUrl + '/api/upload', data: {"id": 2});
  } catch (e) {}
}
