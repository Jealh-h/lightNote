import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

httpGet(String authority, String unencodedPath,
    [Map<String, dynamic>? queryParameters]) async {
  var url = Uri.https(authority, unencodedPath, queryParameters);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
