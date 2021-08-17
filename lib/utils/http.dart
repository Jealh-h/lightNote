import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

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
  var url = Uri.parse(uri);
  var response = await http.post(url, body: param);
  return convert.jsonDecode(response.body) as Map<String, dynamic>;
}
