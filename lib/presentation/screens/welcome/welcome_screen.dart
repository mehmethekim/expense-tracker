import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../screens/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String familyId; // ✅ receive familyId

  const WelcomeScreen({super.key, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cambridgeBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Title
              Text(
                "Expense Tracker",
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive',
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

              const Spacer(flex: 3),

              // Bigger button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintCream,
                  foregroundColor: AppColors.blackBean,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(familyId: familyId), // ✅ pass familyId
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Let’s see!",
                      style: TextStyle(fontSize: 18),
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
