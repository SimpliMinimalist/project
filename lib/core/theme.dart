import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFF7A21);
const Color backgroundColor = Color(0xFFF2F2F2);

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: backgroundColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: primaryColor,
  ),
  textTheme: GoogleFonts.robotoTextTheme(
    const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
      bodyLarge: TextStyle(fontSize: 16.0),
      labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Reverted from 8.0 to 12.0
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);