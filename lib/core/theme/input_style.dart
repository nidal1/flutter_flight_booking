import 'package:flutter/material.dart';
import 'package:flutter_flight_booking/core/theme/color_schemes.dart';

final _baseBorderRadius = BorderRadius.circular(8);

final lightInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: lightColorScheme.surface,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: lightColorScheme.outline),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: lightColorScheme.outline),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: lightColorScheme.error),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: lightColorScheme.error, width: 2),
  ),
  hintStyle: TextStyle(color: lightColorScheme.onSurfaceVariant, fontSize: 14),
  labelStyle: TextStyle(
    color: lightColorScheme.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  errorStyle: TextStyle(color: lightColorScheme.error, fontSize: 12),
);

final darkInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: darkColorScheme.surfaceContainerHighest,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  border: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: darkColorScheme.outline),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: darkColorScheme.outline),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: darkColorScheme.error),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: _baseBorderRadius,
    borderSide: BorderSide(color: darkColorScheme.error, width: 2),
  ),
  hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant, fontSize: 14),
  labelStyle: TextStyle(
    color: darkColorScheme.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  errorStyle: TextStyle(color: darkColorScheme.error, fontSize: 12),
);
