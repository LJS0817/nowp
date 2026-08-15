import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier {

  ///0 - background
  ///1 - textColor
  ///2 - circleColor
  final List<List<Color>> colorList = [
    [ Color(0xFF0D1626), Color(0xFFDAE5FF), Color(0xFF394456) ],
    [ Color(0xFF26240D), Color(0xFFFFFCCA), Color(0xFF656346) ],
    [ Color(0xFF260D0D), Color(0xFFFFDFDF), Color(0xFF6B4D4D) ],
    [ Color(0xFF301C3B), Color(0xFFEBC5FF), Color(0xFF6E5A79) ],
    [ Color(0xFF0D2D2C), Color(0xFFCBFFFC), Color(0xFF405757) ],
  ];

  int themeIndex = 0;
  int get MAX_INDEX => colorList.length;

  Color getColor(int idx) {
    return colorList[themeIndex][idx];
  }

  void changeTheme() {
    themeIndex++;
    if(themeIndex >= MAX_INDEX) {
      themeIndex = 0;
    }
    notifyListeners();
  }
}