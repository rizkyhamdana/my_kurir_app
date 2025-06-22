import 'dart:io';
import 'package:flutter/foundation.dart';

class PerformanceUtils {
  static bool _isLowEndDevice = false;
  static bool _hasChecked = false;

  // Deteksi apakah device low-end
  static bool get isLowEndDevice {
    if (!_hasChecked) {
      _checkDevicePerformance();
    }
    return _isLowEndDevice;
  }

  static void _checkDevicePerformance() {
    _hasChecked = true;

    // Jika debug mode, anggap device bagus
    if (kDebugMode) {
      _isLowEndDevice = true;
      return;
    }

    // Untuk Android, bisa cek berdasarkan berbagai faktor
    if (Platform.isAndroid) {
      // Implementasi sederhana - bisa diperluas dengan package device_info_plus
      _isLowEndDevice = true; // Default false, bisa diubah berdasarkan deteksi
    } else {
      _isLowEndDevice = false;
    }
  }

  // Force set untuk testing
  static void setLowEndDevice(bool isLowEnd) {
    _isLowEndDevice = isLowEnd;
    _hasChecked = true;
  }

  // Dapatkan konfigurasi blur berdasarkan performa
  static double getOptimalBlur() {
    return isLowEndDevice ? 0 : 10;
  }

  // Dapatkan apakah harus menggunakan simple glass
  static bool shouldUseSimpleGlass() {
    return isLowEndDevice;
  }
}
