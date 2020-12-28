import 'package:flutter/material.dart';

class Styles {

  static Color indigoAccentColor, greyIconColor, white54IconColor, whiteTextFieldColor;

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {

    indigoAccentColor = isDarkTheme ? Colors.deepPurple : Colors.indigoAccent;
    greyIconColor = isDarkTheme ? Colors.white54 : Colors.grey;
    white54IconColor = isDarkTheme ? Colors.white10 : Colors.white54;
    whiteTextFieldColor = isDarkTheme ? Colors.white10 : Colors.white;

    return ThemeData(
      primarySwatch: Colors.indigo,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
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
        elevation: 0.0,
      ),
    );
  }
}
