import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const COLOR_PURPLE = Color(0xff8A3CF1);
const COLOR_PINK = Color(0xffE94CBA);
const COLOR_WHITE = Color(0xffF1F3FA);
const COLOR_PURE_WHITE = Color(0xffFFFFFF);
const COLOR_GRAY = Color(0xffF1F3FA);
const COLOR_DARK_GRAY = Colors.grey;
const COLOR_LIGHT_GRAY = Color(0xffE5E5E5);

const String dev_endpoint = "http://10.0.2.2:8000";

ThemeData createTheme(BuildContext context) {
  return ThemeData(
    // appBarTheme: appBarTheme,
    scaffoldBackgroundColor: COLOR_GRAY,
    primarySwatch: Colors.deepPurple,
    textTheme: TextTheme(
      headline5: GoogleFonts.play(),
      headline6: GoogleFonts.play(),
      bodyText2: GoogleFonts.play(
        color: Colors.black,
      ),
      bodyText1: GoogleFonts.play(),
      headline4: GoogleFonts.play(),
      headline3: GoogleFonts.play(),
      headline2: GoogleFonts.play(),
      headline1: GoogleFonts.play(),
      subtitle2: GoogleFonts.roboto(),

      // used in text fields
      subtitle1: GoogleFonts.play(),
      caption: GoogleFonts.roboto(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(.6))),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(.6))),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelStyle: GoogleFonts.roboto(
          fontSize: 16, color: Colors.white.withOpacity(0.6)),
      hintStyle: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white.withOpacity(0.6),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.accent,
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.white,
            // secondary will be the textColor, when the textTheme is set to accent
            secondary: COLOR_PURPLE,
          ),
    ),
  );
}
