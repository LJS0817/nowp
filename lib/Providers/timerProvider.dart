import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerProvider extends ChangeNotifier {
  DateTime date = DateTime.now();

  late Timer timer;

  void init() {
    timer = Timer.periodic(const Duration(seconds: 1), callback);
  }

  Future<void> callback(Timer t) async {
    date = DateTime.now();
    notifyListeners();
  }
}