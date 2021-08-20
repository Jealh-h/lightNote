import 'package:flutter/cupertino.dart';

class EmailModel with ChangeNotifier {
  String _email = '';
  String get email => _email;
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
