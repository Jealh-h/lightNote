import 'package:flutter/cupertino.dart';

class EmailModel with ChangeNotifier {
  String _email = '';
  String get email => _email;
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  int _fontsize = 10;
  int get fontsize => _fontsize;
  void setSize(int size) {
    _fontsize = size;
    notifyListeners();
  }
}
