import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/expense.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensePieChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Group expenses by category
    final Map<String, double> categoryTotals = {};
    for (final e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final List<Color> colors = [
      AppColors.caputMortuum,
      AppColors.cambridgeBlue,
      Colors.amber.shade600,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Legend with fixed width
          SizedBox(
            width: 140, // fixes overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categoryTotals.entries.map((entry) {
                final category = entry.key;
                final amount = entry.value;
                final percentage =
                    total == 0 ? 0 : (amount / total * 100).round();

                final color = category == "Living Costs"
                    ? AppColors.caputMortuum
                    : category == "Daily Needs"
                        ? AppColors.cambridgeBlue
                        : Colors.amber.shade600;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 8, backgroundColor: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "$percentage%   ${amount.toStringAsFixed(2)} ₺",
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Pie chart with fixed size
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50, // keeps thin ring
                sectionsSpace: 2,
                sections: categoryTotals.entries.map((entry) {
                  final category = entry.key;
                  final amount = entry.value;
                  final percentage =
                      total == 0 ? 0 : (amount / total * 100).round();

                  final color = category == "Living Costs"
                      ? AppColors.caputMortuum
                      : category == "Daily Needs"
                          ? AppColors.cambridgeBlue
                          : Colors.amber.shade600;

                  return PieChartSectionData(
                    value: amount,
                    color: color,
                    radius: 22,
                    showTitle: false, // no text inside
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
