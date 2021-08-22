import 'package:flutter/cupertino.dart';

class ComsumptionModel with ChangeNotifier {
  int _index = 0;
  DateTime? _time;
  int get index => _index;
  DateTime? get time => _time;
  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void setTime(DateTime time) {
    _time = time;
    notifyListeners();
  }
}
