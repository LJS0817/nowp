import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Home extends StatefulWidget {
  Home({super.key});

  String title = "";
  String sub = "";

  Uint8List fingerImages = Uint8List.fromList([]);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const eventPlatform = EventChannel("example.com/event");
  static const platform = MethodChannel("example.com/test");

  void changeTitle(String str) {
    setState(() {
      widget.title = str.split('`')[0];
      widget.sub = str.split('`')[1];
    });
  }

  Future<void> test(int id) async {
    try {
      String val = await platform.invokeMethod("getData$id");
      log(val.toString());
      changeTitle(val);
    } on PlatformException catch(e) {
      throw e;
    }
  }

  void clicked(int id) async {
    test(id);
  }

  @override
  void initState() {
    platform.setMethodCallHandler((call) async {
      if(call.method.contains("init")) {
        changeTitle(call.arguments);
      }
      if(call.method.contains("img")) {
        // log(widget.fingerImages.length.toString());
        setState(() {
          widget.fingerImages = Uint8List.fromList(call.arguments);
          log(widget.fingerImages.length.toString());
        });
      }
    });
    eventPlatform.receiveBroadcastStream().listen((event) {
      log("Current notification: $event");
    });
    WakelockPlus.enable();
    super.initState();

  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  Widget button(int id) {
    return Material(
        child: InkWell(
          onTap: () {
            clicked(id);
          },
          child: Container(
            width: 200,
            height: 100,
            color: Colors.black,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(widget.title),
            Text(widget.sub),
            widget.fingerImages.length > 0 ? Image.memory(widget.fingerImages,
              width: 100,
              height: 100,
              fit: BoxFit.contain,) : SizedBox(),
            Row(
              children: [
                button(0),
                button(1),
                button(2),
              ],
            )
          ]
        ),
      ),
    );
  }
}
