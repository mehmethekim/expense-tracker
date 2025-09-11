import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.cambridgeBlue,
    scaffoldBackgroundColor: AppColors.mintCream,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.caputMortuum,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.cambridgeBlue,
      secondary: AppColors.celadon,
      surface: AppColors.mintCream,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.blackBean,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.blackBean,
      ),
    ),
  );
}