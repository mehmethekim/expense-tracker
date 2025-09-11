import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Living Costs":
        return AppColors.caputMortuum;
      case "Daily Needs":
        return AppColors.cambridgeBlue;
      case "Extras":
        return Colors.amber.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // User indicator
            CircleAvatar(
              radius: 20,
              backgroundColor: expense.user == "Ş"
                  ? AppColors.caputMortuum
                  : AppColors.deepJungleGreen,
              child: Text(
                expense.user,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(width: 16),

            // Expense details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${expense.amount.toStringAsFixed(2)} ₺",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackBean,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    expense.note,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(expense.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          expense.category,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${expense.date.day}/${expense.date.month}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
