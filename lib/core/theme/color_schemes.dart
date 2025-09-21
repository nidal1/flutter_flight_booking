import 'package:flutter/material.dart';

// Light color scheme (shadcn-like gray palette, Material3)
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary (used for AppBar, FloatingActionButton, buttons)
  primary: Color(0xFF111827), // gray-900
  onPrimary: Color(0xFFF9FAFB), // gray-50
  primaryContainer: Color(0xFFE6E8EB), // soft container for primary elements
  onPrimaryContainer: Color(0xFF111827),

  // Secondary (accent / less prominent components)
  secondary: Color(0xFFF3F4F6), // gray-100
  onSecondary: Color(0xFF111827),
  secondaryContainer: Color(0xFFE9EEF2),
  onSecondaryContainer: Color(0xFF111827),

  // Background & Surface
  background: Color(0xFFF8FAFC), // page background (very light)
  onBackground: Color(0xFF0F1720), // main text
  surface: Color(0xFFFFFFFF), // cards, sheets
  onSurface: Color(0xFF0F1720),

  // Variants / tones
  surfaceContainerHighest: Color(0xFFE5E7EB), // subtle surfaces (inputs, chips)
  onSurfaceVariant: Color(0xFF9CA3AF), // muted text
  outline: Color(0xFFD1D5DB), // borders
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF111827),
  onInverseSurface: Color(0xFFF8FAFC),

  // Status colors
  error: Color(0xFFEF4444),
  onError: Color(0xFFFFFFFF),
  // Secondary fields that Material3 supports
  tertiary: Color(0xFF6B7280),
  onTertiary: Color(0xFFF8FAFC),
  tertiaryContainer: Color(0xFFEDEFF3),
  onTertiaryContainer: Color(0xFF111827),

  // surfaceTint used by Material widgets for colored surfaces
  surfaceTint: Color(0xFF111827),
);

// Dark color scheme (shadcn-like but dark)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: Color(0xFFE6E7EA), // light gray for primary in dark mode
  onPrimary: Color(0xFF0F1720),
  primaryContainer: Color(0xFF1F2937), // slightly brighter container
  onPrimaryContainer: Color(0xFFE6E7EA),

  // Secondary
  secondary: Color(0xFF1F2937), // gray-800ish
  onSecondary: Color(0xFFE6E7EA),
  secondaryContainer: Color(0xFF111827),
  onSecondaryContainer: Color(0xFFE6E7EA),

  // Background & Surface
  background: Color(0xFF0B1220), // deep background
  onBackground: Color(0xFFE6E7EA),
  surface: Color(0xFF0F1720), // card background
  onSurface: Color(0xFFE6E7EA),

  // Variants / tones
  surfaceContainerHighest: Color(0xFF111827),
  onSurfaceVariant: Color(0xFF94A3B8),
  outline: Color(0xFF263244),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFF8FAFC),
  onInverseSurface: Color(0xFF0F1720),

  // Status colors
  error: Color(0xFFEF4444),
  onError: Color(0xFF111827),

  // tertiary
  tertiary: Color(0xFF94A3B8),
  onTertiary: Color(0xFF0F1720),
  tertiaryContainer: Color(0xFF253341),
  onTertiaryContainer: Color(0xFFE6E7EA),

  surfaceTint: Color(0xFFE6E7EA),
);
