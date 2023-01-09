import 'package:flutter/material.dart';

class AppThemes {

  /// 亮色
  static ThemeData light = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black87,size: 22.0,),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white),
    colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.white60,
        ),
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white60,
    ),
  );


  /// 暗色
  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Colors.black54,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0.5,
      iconTheme: IconThemeData(color: Colors.white,size: 22.0,),
      backgroundColor: Colors.black54,
      titleTextStyle: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.black54),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.black54,
    ),
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black54
    ),
  );

}