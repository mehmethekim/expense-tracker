import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/toggle_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // default: Expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintCream,
      appBar: AppBar(
        //title: const Text("Expense Tracker"),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cambridgeBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ToggleTabs(
              selectedIndex: _selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedIndex == 1
                ? const Center(child: Text("Expense Content"))
                : const Center(child: Text("Income Content")),
          ),
        ],
      ),
    );
  }
}
