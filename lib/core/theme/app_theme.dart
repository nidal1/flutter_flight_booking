import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/core/theme/buttons_style.dart';
import 'package:flutter_flight_booking/core/theme/input_style.dart';
import 'package:flutter_flight_booking/core/theme/color_schemes.dart';

ThemeData buildLightTheme(String fontFamily) {
  final baseTheme = ThemeData.light(useMaterial3: true);
  return baseTheme.copyWith(
    colorScheme: lightColorScheme,
    textTheme: baseTheme.textTheme.apply(fontFamily: fontFamily),
    primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: fontFamily),
    filledButtonTheme: lightFilledButtonTheme,
    elevatedButtonTheme: lightElevatedButtonTheme,
    outlinedButtonTheme: lightOutlinedButtonTheme,
    textButtonTheme: lightTextButtonTheme,
    iconButtonTheme: lightIconButtonTheme,
    inputDecorationTheme: lightInputDecorationTheme,
  );
}

ThemeData buildDarkTheme(String fontFamily) {
  final baseTheme = ThemeData.dark(useMaterial3: true);
  return baseTheme.copyWith(
    colorScheme: darkColorScheme,
    textTheme: baseTheme.textTheme.apply(fontFamily: fontFamily),
    primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: fontFamily),
    filledButtonTheme: darkFilledButtonTheme,
    elevatedButtonTheme: darkElevatedButtonTheme,
    outlinedButtonTheme: darkOutlinedButtonTheme,
    textButtonTheme: darkTextButtonTheme,
    iconButtonTheme: darkIconButtonTheme,
    inputDecorationTheme: darkInputDecorationTheme,
  );
}
