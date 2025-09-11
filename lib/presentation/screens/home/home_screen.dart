import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/toggle_tabs.dart';
import '../../../data/models/expense.dart';
import '../../widgets/expense_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // default: Expense
  final List<Expense> _expenses = [];
  String? _selectedCategoryFilter; // null = show all

  Widget _buildCategoryTab(String label, Color color) {
    final bool isSelected = _selectedCategoryFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategoryFilter == label) {
            _selectedCategoryFilter = null; // toggle off
          } else {
            _selectedCategoryFilter = label;
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 3),
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  // Method to add new expense
  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  // Show bottom sheet for adding expense
  void _showAddExpenseSheet() {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = "Living Costs";
    String selectedUser = "M"; // default user

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User selector (M / Ş)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text("M"),
                          selected: selectedUser == "M",
                          selectedColor: AppColors.deepJungleGreen,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedUser = "M");
                            }
                          },
                          labelStyle: TextStyle(
                            color: selectedUser == "M"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text("Ş"),
                          selected: selectedUser == "Ş",
                          selectedColor: AppColors.caputMortuum,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedUser = "Ş");
                            }
                          },
                          labelStyle: TextStyle(
                            color: selectedUser == "Ş"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Category selector
                    Wrap(
                      spacing: 12,
                      children: [
                        ChoiceChip(
                          label: const Text("Living Costs"),
                          selected: selectedCategory == "Living Costs",
                          selectedColor: AppColors.caputMortuum,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() =>
                                  selectedCategory = "Living Costs");
                            }
                          },
                          labelStyle: TextStyle(
                            color: selectedCategory == "Living Costs"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        ChoiceChip(
                          label: const Text("Daily Needs"),
                          selected: selectedCategory == "Daily Needs",
                          selectedColor: AppColors.cambridgeBlue,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() =>
                                  selectedCategory = "Daily Needs");
                            }
                          },
                          labelStyle: TextStyle(
                            color: selectedCategory == "Daily Needs"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        ChoiceChip(
                          label: const Text("Extras"),
                          selected: selectedCategory == "Extras",
                          selectedColor: Colors.amber.shade600,
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedCategory = "Extras");
                            }
                          },
                          labelStyle: TextStyle(
                            color: selectedCategory == "Extras"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Amount input
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.caputMortuum,
                      ),
                      decoration: InputDecoration(
                        labelText: "Enter Expense",
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Note input
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: "Note",
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Add button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepJungleGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final expense = Expense(
                          amount:
                              double.tryParse(amountController.text) ?? 0.0,
                          note: noteController.text,
                          category: selectedCategory,
                          date: DateTime.now(),
                          user: selectedUser,
                        );
                        _addExpense(expense);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintCream,
      appBar: AppBar(
        backgroundColor: AppColors.cambridgeBlue,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ToggleTabs(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const SizedBox(height: 20),
          // Category filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCategoryTab("Living Costs", AppColors.caputMortuum),
                const SizedBox(width: 8),
                _buildCategoryTab("Daily Needs", AppColors.cambridgeBlue),
                const SizedBox(width: 8),
                _buildCategoryTab("Extras", Colors.amber.shade600),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 1
                ? Builder(
                    builder: (context) {
                      // apply filter here
                      final filteredExpenses = _selectedCategoryFilter == null
                          ? _expenses
                          : _expenses
                              .where((e) => e.category == _selectedCategoryFilter)
                              .toList();

                      return ListView.builder(
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          return ExpenseCard(expense: filteredExpenses[index]);
                        },
                      );
                    },
                  )
                : const Center(child: Text("Income Content")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.deepJungleGreen,
        onPressed: _showAddExpenseSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
