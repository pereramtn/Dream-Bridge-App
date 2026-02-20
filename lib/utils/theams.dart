import 'package:flutter/material.dart';

class TheamsModeData {
  //light mode
  final ThemeData lightmode = ThemeData(
    brightness: Brightness.light,

    fontFamily:'KoHo' ,
    primarySwatch: Colors.teal,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: 'KoHo' ,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  //darkmode

  final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,

    fontFamily:'KoHo' ,
    primarySwatch: Colors.blueGrey,

    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: const Color.fromARGB(255, 185, 182, 182),
        fontFamily:'KoHo' ,
        fontSize: 20,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    scaffoldBackgroundColor:Color.fromARGB(255, 97, 115, 114),

  );
}
