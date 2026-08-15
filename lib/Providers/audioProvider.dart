import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AudioProvider extends ChangeNotifier {
  String title = "";
  String sub = "";

  Uint8List image = Uint8List.fromList([]);

  static const eventPlatform = EventChannel("example.com/event");
  static const platform = MethodChannel("example.com/test");

  void changeTitle(String str) {
    title = str.split('`')[0];
    sub = str.split('`')[1];
    notifyListeners();
  }

  Future<void> test(int id) async {
    try {
      String val = await platform.invokeMethod("getData$id");
      // log(val.toString());
      changeTitle(val);
    } on PlatformException catch(e) {
      throw e;
    }
  }

  void clicked(int id) async {
    test(id);
  }

  void changeImage(dynamic obj) {
    image = Uint8List.fromList(obj);
    notifyListeners();
  }

  void init() {
    platform.setMethodCallHandler((call) async {
      if(call.method.contains("init")) {
        changeTitle(call.arguments);
      }
      if(call.method.contains("img")) {
        changeImage(call.arguments);
      }
    });
    eventPlatform.receiveBroadcastStream().listen((event) {
      log("Current notification: $event");
    });
  }

}