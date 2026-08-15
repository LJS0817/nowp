import 'dart:async';
import 'dart:developer' as Log;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nowp/Providers/audioProvider.dart';
import 'package:nowp/Providers/themeProvider.dart';
import 'package:nowp/Providers/timerProvider.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:nowp/vertical.dart';
import 'package:nowp/timer.dart';


bool isSetAlert = false;
bool arrowUp = true;

//요일을 넘겨준다.
String getWeekday(int i) {
  switch(i) {
    case 1: return "MON";
    case 2: return "TUE";
    case 3: return "WED";
    case 4: return "THU";
    case 5: return "FRI";
    case 6: return "SAT";
    case 7: return "SUN";
    default: return "MON";
  // case 1: return "월요일";
  // case 2: return "화요일";
  // case 3: return "수요일";
  // case 4: return "목요일";
  // case 5: return "금요일";
  // case 6: return "토요일";
  // case 7: return "일요일";
  // default: return "월요일";
  }
}


class Home2 extends StatefulWidget {
  Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
    Provider.of<TimerProvider>(context, listen: false).init();
    Provider.of<AudioProvider>(context, listen: false).init();
  }


  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    TimerProvider timer = Provider.of<TimerProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Material(
          child: InkWell(
            onTap: () {
              theme.changeTheme();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: theme.getColor(0),
              child: Vertical(timer.date),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 앱이 꺼지기 전에 타이머를 꺼준다.
    Provider.of<TimerProvider>(context).timer.cancel();
    WakelockPlus.disable();
    super.dispose();
  }
}