import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../screens/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cambridgeBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // pushes title a bit upward

              // Title
              Text(
                "Expense Tracker",
                style: TextStyle(
                  fontSize: 55, // bigger
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive', // replace with Google Fonts later
                  color: AppColors.mintCream,
                ),
              ),

              const SizedBox(height: 8),

              // Horizontal line
              Container(
                width: 250,
                height: 5,
                color: AppColors.mintCream.withOpacity(0.8),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Manage Your Expenses",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mintCream.withOpacity(0.9),
                ),
              ),

              const Spacer(flex: 3), // gives space before button

              // Bigger button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintCream,
                  foregroundColor: AppColors.blackBean,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, // wider
                    vertical: 20,  // taller
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Let’s see!",
                      style: TextStyle(fontSize: 18), // larger text
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward, size: 22),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
