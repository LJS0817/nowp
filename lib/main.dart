import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nowp/Providers/audioProvider.dart';
import 'package:nowp/Providers/themeProvider.dart';
import 'package:nowp/Providers/timerProvider.dart';
import 'package:nowp/home2.dart';
import 'package:nowp/timer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  //휴대폰 전체화면
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  WakelockPlus.enable();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'text',
          useMaterial3: true,
        ),
        home: Home2(),
      ),
    );
  }
}