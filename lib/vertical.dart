import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nowp/Providers/audioProvider.dart';
import 'package:nowp/home2.dart';
import 'package:provider/provider.dart';

import 'Providers/themeProvider.dart';

class Vertical extends StatelessWidget {
  late DateTime date;

  Vertical(DateTime time, {super.key}) {
    date = time;
  }

  //시간 계산을 해준다.
  Widget timeBox(int t, int timeType, Color c, {double fSize=180}) {
    return Container(
      alignment: timeType == 0 ? Alignment.centerRight : timeType == 1 ? Alignment.centerLeft : Alignment.center,
      width: double.maxFinite,
      child: Text(
        "${t < 10 ? "0$t" : t}",
        style: TextStyle(
          fontSize: fSize,
          color: c,
          height: 1,
        ),
      ),
    );
  }

  Widget home(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Container(
        alignment: Alignment.center,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${date.month < 10 ? "0${date.month}" : date.month} - ${date.day < 10 ? "0${date.day}" : date.day} [ ${getWeekday(date.weekday)} ]",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: theme.getColor(1),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: timeBox(date.hour, 0, theme.getColor(1))),
                SizedBox(width: 25, child: Text(":", textAlign: TextAlign.center, style: TextStyle(color: theme.getColor(1), fontSize: 95),),),
                Expanded(child: timeBox(date.minute, 1, theme.getColor(1))),
                // timeBox(date.minute),
              ],
            ),
            timeBox(date.second, 2, theme.getColor(1), fSize: 50),
          ],
        )
    );
  }

  Widget CircleWidget(BuildContext context, {double? left, double? right, double? top, double? bottom, double? size, EdgeInsets? padding, Widget? c, Color? color}) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: SizedBox(
        width: size,
        height: size,
        child: OverflowBox(
          maxHeight: size,
          maxWidth: size,
          child: AnimatedContainer(
            duration: 400.milliseconds,
            decoration: BoxDecoration(
              color: color ?? theme.getColor(2),
              borderRadius: BorderRadius.circular(1000),
            ),
            alignment: Alignment.center,
            padding: padding,
            child: c,
          ),
        ),
      ).animate(onPlay: (con) { con.repeat(reverse: true); }, delay: (size!*0.05).seconds).moveY(duration: 5.seconds, begin: 10, curve: Curves.fastOutSlowIn).moveX(duration: 5.seconds, begin: 5, curve: Curves.easeInOutCirc),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    AudioProvider audio = Provider.of<AudioProvider>(context);
    return Stack(
      children: [
        CircleWidget(context, left: 190, bottom: 60, size: 50),

        CircleWidget(context, left: -10, bottom: -10, size: 170),
        CircleWidget(context, right: 220, top: 40, size: 90),
        CircleWidget(context, right: 320, bottom: 40, size: 140),

        CircleWidget(context, left: 70, top: 50, size: 70),
        CircleWidget(context, left: 150, top: 80, size: 30),

        CircleWidget(context, left: 300, top: 100, size: 100),

        CircleWidget(context, right: 280, bottom: 15, size: 65, color: theme.getColor(1)).animate(target: isSetAlert ? 1 : 0).fade(duration: 400.milliseconds, begin: 0, end: 1),

        Positioned(
          right: 80,
          top: 100,
          child: Column(
            children: [
              Container(
                width: 100,
                alignment: Alignment.center,
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text : TextSpan(
                    text: audio.title,
                    style: TextStyle(
                      color: theme.getColor(1),
                    ),
                  ),
                ),
              ),
              Text(
                audio.sub,
                style: TextStyle(
                  color: theme.getColor(1),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 150,
                height: 150,
                child: OverflowBox(
                  maxHeight: 150,
                  maxWidth: 150,
                  child: AnimatedContainer(
                    duration: 400.milliseconds,
                    decoration: BoxDecoration(
                      color: theme.getColor(2),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(1000),
                      child: InkWell(
                        splashColor: theme.getColor(1).withOpacity(0.5),
                        highlightColor: theme.getColor(1).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1000),
                        onTap: () {
                          audio.clicked(1);
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: audio.image.length > 0 ? Image.memory(
                            audio.image,
                            width: 150,
                            fit: BoxFit.contain,
                          ) : SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate(onPlay: (con) { con.repeat(reverse: true); }, delay: (150*0.05).seconds).moveY(duration: 5.seconds, begin: 10, curve: Curves.fastOutSlowIn).moveX(duration: 5.seconds, begin: 5, curve: Curves.easeInOutCirc),
            ],
          ),
        ),
        CircleWidget(
          context,
          right: 50,
          bottom: 50,
          size: 50,
          color: theme.getColor(1),
          c : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(1000),
            child: InkWell(
              splashColor: theme.getColor(2).withOpacity(0.5),
              highlightColor: theme.getColor(2).withOpacity(0.5),
              borderRadius: BorderRadius.circular(1000),
              onTap: () {
                audio.clicked(2);
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                ),
                child: Text(
                  "->",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: theme.getColor(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        CircleWidget(
          context,
          right: 200,
          bottom: 50,
          size: 50,
          color: theme.getColor(1),
          c : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(1000),
            child: InkWell(
              splashColor: theme.getColor(2).withOpacity(0.5),
              highlightColor: theme.getColor(2).withOpacity(0.5),
              borderRadius: BorderRadius.circular(1000),
              onTap: () {
                audio.clicked(0);
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                ),
                child: Text(
                  "<-",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: theme.getColor(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: home(context),
        ),
      ],
    );
  }
}
