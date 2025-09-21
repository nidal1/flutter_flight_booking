import 'package:flutter/material.dart';
import 'color_schemes.dart';

// Shared constants
final _basePadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
final _baseTextStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
final _baseShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8),
);

// --- Light Button Themes ---
final lightElevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      final color = lightColorScheme.primary;
      return states.contains(WidgetState.disabled)
          ? color.withOpacity(0.5)
          : color;
    }),
    foregroundColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
    padding: WidgetStateProperty.all(_basePadding),
    textStyle: WidgetStateProperty.all(_baseTextStyle),
    shape: WidgetStateProperty.all(_baseShape),
    elevation: WidgetStateProperty.all(0),
  ),
);

final lightOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: lightColorScheme.primary,
    side: BorderSide(color: lightColorScheme.primary),
    padding: _basePadding,
    textStyle: _baseTextStyle,
    shape: _baseShape,
  ),
);

final lightTextButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: lightColorScheme.primary,
    padding: _basePadding,
    textStyle: _baseTextStyle,
  ),
);

final lightFilledButtonTheme = FilledButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      final color = lightColorScheme.primary;
      return states.contains(WidgetState.disabled)
          ? color.withOpacity(0.5)
          : color;
    }),
    foregroundColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
    padding: WidgetStateProperty.all(_basePadding),
    textStyle: WidgetStateProperty.all(_baseTextStyle),
    shape: WidgetStateProperty.all(_baseShape),
    elevation: WidgetStateProperty.all(0),
  ),
);

final lightIconButtonTheme = IconButtonThemeData(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      final color = lightColorScheme.primary;
      return states.contains(WidgetState.disabled)
          ? color.withOpacity(0.5)
          : color;
    }),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return lightColorScheme.primary.withOpacity(0.1);
      }
      return null;
    }),
    shape: WidgetStateProperty.all(_baseShape),
  ),
);

// --- Dark Button Themes ---
final darkElevatedButtonTheme = ElevatedButtonThemeData(
  style: lightElevatedButtonTheme.style?.copyWith(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      final color = darkColorScheme.primary;
      return states.contains(WidgetState.disabled)
          ? color.withOpacity(0.5)
          : color;
    }),
    foregroundColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
  ),
);

final darkOutlinedButtonTheme = OutlinedButtonThemeData(
  style: lightOutlinedButtonTheme.style?.copyWith(
    foregroundColor: WidgetStateProperty.all(darkColorScheme.primary),
    side: WidgetStateProperty.all(BorderSide(color: darkColorScheme.primary)),
  ),
);

final darkTextButtonTheme = TextButtonThemeData(
  style: lightTextButtonTheme.style?.copyWith(
    foregroundColor: WidgetStateProperty.all(darkColorScheme.primary),
  ),
);

final darkFilledButtonTheme = FilledButtonThemeData(
  style: lightFilledButtonTheme.style?.copyWith(
    backgroundColor: WidgetStateProperty.all(darkColorScheme.primary),
    foregroundColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
  ),
);

final darkIconButtonTheme = IconButtonThemeData(
  style: lightIconButtonTheme.style?.copyWith(
    foregroundColor: WidgetStateProperty.all(darkColorScheme.primary),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return darkColorScheme.primary.withOpacity(0.1);
      }
      return null;
    }),
  ),
);
