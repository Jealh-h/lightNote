import 'package:flutter/cupertino.dart';

class UUidModel with ChangeNotifier {
  String _uuid = '';
  String get uuid => _uuid;
  void setEmail(String uuid) {
    _uuid = uuid;
    notifyListeners();
  }
}
