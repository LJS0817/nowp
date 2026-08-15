import 'package:flutter/cupertino.dart';

class Counter extends ChangeNotifier {
  Counter() {
    _minutes = 0;
    _seconds = 0;
    isPlaying = false;
  }

  static const int LIMITED_MINUTE = 99;
  static const int LIMITED_SECOND = 59;

  int _minutes = 0;
  int _seconds = 0;

  bool isPlaying = false;

  void increaseSecond() {
    _seconds++;
    if(_seconds > LIMITED_SECOND) {
      _seconds = LIMITED_SECOND;
    }
    notifyListeners();
  }

  void increaseMinute() {
    _minutes++;
    if(_minutes > LIMITED_MINUTE) {
      _minutes = LIMITED_MINUTE;
    }
    notifyListeners();
  }

  void decreaseSeconds() {
    _seconds--;
    if(_seconds < 0) {
      if(_minutes <= 0) {
        isPlaying = false;
        return;
      }
      _seconds = LIMITED_SECOND;
      decreaseMinutes();
    }
    notifyListeners();
  }

  void decreaseMinutes() {
    _minutes--;
  }
}