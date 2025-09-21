import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flight_booking/core/constants/app_constants.dart';

class AppSettings {
  final bool isDark;
  final bool isRtl;
  final bool isFirstLoad;

  AppSettings({
    required this.isDark,
    required this.isRtl,
    required this.isFirstLoad,
  });

  AppSettings copyWith({bool? isDark, bool? isRtl, bool? isFirstLoad}) {
    return AppSettings(
      isDark: isDark ?? this.isDark,
      isRtl: isRtl ?? this.isRtl,
      isFirstLoad: isFirstLoad ?? this.isFirstLoad,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier()
    : super(AppSettings(isDark: false, isRtl: false, isFirstLoad: true)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(LocalStorageKeys.isDark) ?? false;
    final isRtl = prefs.getBool(LocalStorageKeys.isRtl) ?? false;
    final isFirstLoad = prefs.getBool(LocalStorageKeys.isFirstLoad) ?? true;
    state = AppSettings(isDark: isDark, isRtl: isRtl, isFirstLoad: isFirstLoad);
  }

  Future<void> toggleDark() async {
    final newValue = !state.isDark;
    state = state.copyWith(isDark: newValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.isDark, newValue);
  }

  Future<void> toggleRtl() async {
    final newValue = !state.isRtl;
    state = state.copyWith(isRtl: newValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.isRtl, newValue);
  }

  Future<void> toggleFirstLoad() async {
    if (!state.isFirstLoad) {
      return;
    }
    final newValue = !state.isFirstLoad;
    state = state.copyWith(isFirstLoad: newValue);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(LocalStorageKeys.isFirstLoad, newValue);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      return AppSettingsNotifier();
    });
