import 'package:flutter/cupertino.dart';

class CoverModel with ChangeNotifier {
  String _cover = '';
  String get cover => _cover;
  void setCoverl(String cover) {
    _cover = cover;
    notifyListeners();
  }
}
