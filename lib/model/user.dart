import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String username = '';
  String id = '';
  String email = '';
  String avatarUrl = '';
  Map get user =>
      {"username": username, "id": id, "email": email, "avatarUrl": avatarUrl};
  void setUserInfo(Map user) {
    this.username = user["username"];
    this.email = user["email"];
    this.avatarUrl = user["avatarUrl"];
    this.id = user["id"];
    notifyListeners();
  }
}
