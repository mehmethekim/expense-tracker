import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ToggleTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ToggleTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTab("Income", 0, isLeft: true),
        const SizedBox(width: 8), // gap between tabs
        _buildTab("Expense", 1, isLeft: false),
      ],
    );
  }

  Widget _buildTab(String label, int index, {required bool isLeft}) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        width: 180, // fixed width for better look
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepJungleGreen : Colors.grey.shade400,
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
