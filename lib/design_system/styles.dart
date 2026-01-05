import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2F6BFF);
  static const Color background = Color(0xFFF7FBFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF0F172A);
  static const Color muted = Color(0xFF647488);
  static const Color border = Color(0xFFE2E8F0);
  static const Color danger = Color(0xFFEF4444);
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text, fontFamily: 'Inter');
  static const TextStyle section = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text, fontFamily: 'Inter');
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.text, fontFamily: 'Inter');
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.muted, fontFamily: 'Inter');
  static const TextStyle button = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Inter');
}