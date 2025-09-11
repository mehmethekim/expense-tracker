import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/welcome/welcome_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Expense Tracker',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
