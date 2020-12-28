import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles {
  static Color indigoAccentColor,
      greyIconColor,
      white54IconColor,
      whiteTextFieldColor;
  static MaterialColor indigoColor;

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    indigoAccentColor = isDarkTheme ? Colors.deepPurple : Colors.indigoAccent;
    greyIconColor = isDarkTheme ? Colors.white70 : Colors.grey;
    white54IconColor = isDarkTheme ? Colors.white70 : Colors.white54;
    whiteTextFieldColor = isDarkTheme ? Colors.white70 : Colors.white;
    indigoColor = isDarkTheme ? Colors.lightBlue : Colors.indigo;

    return ThemeData(
      primarySwatch: indigoColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : Colors.brown[50],
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.white54 : Color(0xffEECED3),
      highlightColor: Colors.transparent,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        color: isDarkTheme ? Colors.black12 : indigoColor,
        textTheme: Theme.of(context).textTheme.apply(displayColor: whiteTextFieldColor),
        elevation: 0.0,
      ),
    );
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}


class DarkThemePreference {
  static const THEME_STATUS = "theme_status";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
