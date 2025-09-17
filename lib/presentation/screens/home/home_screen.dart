import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/toggle_tabs.dart';
import '../../../data/models/expense.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/expense_pie_chart.dart';
import '../../../data/services/firestore_service.dart';
import '../settings/settings_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.familyId});

  final String familyId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // default: Expense
  String? _selectedCategoryFilter;
  bool _isEditingIncome = false;
  final TextEditingController _incomeController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _firestoreService.ensureFamilyExists(widget.familyId);
  }
  // Category tabs
  Widget _buildCategoryTab(String label, Color color) {
    final bool isSelected = _selectedCategoryFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategoryFilter == label) {
            _selectedCategoryFilter = null;
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

  // Show bottom sheet for adding expense
  void _showAddExpenseSheet(double currentIncome) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = "Living Costs";
    String selectedUser = "M";

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
                    // User selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text("M"),
                          selected: selectedUser == "M",
                          selectedColor: AppColors.deepJungleGreen,
                          onSelected: (val) {
                            if (val) setModalState(() => selectedUser = "M");
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
                            if (val) setModalState(() => selectedUser = "Ş");
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
                              setModalState(() => selectedCategory = "Living Costs");
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
                              setModalState(() => selectedCategory = "Daily Needs");
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final expense = Expense(
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          note: noteController.text,
                          category: selectedCategory,
                          date: DateTime.now(),
                          user: selectedUser,
                        );
                        _firestoreService.addExpense(widget.familyId, expense);

                        // decrease income
                        _firestoreService.updateIncome(
                          widget.familyId,
                          currentIncome - expense.amount,
                        );

                        Navigator.pop(context);
                      },
                      child: const Text("Add", style: TextStyle(fontSize: 18)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(familyId: widget.familyId),
                ),
              );
            },
          ),
        ],
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

          // INCOME TAB
          if (_selectedIndex == 0)
            Expanded(
              child: StreamBuilder<Map<String, dynamic>?>(
                stream: _firestoreService.getIncome(widget.familyId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final incomeData = snapshot.data;
                  final totalIncome = incomeData?['income']?.toDouble() ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text("Total Income",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackBean,
                            )),
                        const SizedBox(height: 16),
                        Text(
                          "${totalIncome.toStringAsFixed(2)} ₺",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 40),

                        if (_isEditingIncome) ...[
                          TextField(
                            controller: _incomeController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.caputMortuum,
                            ),
                            decoration: InputDecoration(
                              labelText: "Enter Income",
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.deepJungleGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                ),
                                onPressed: () {
                                  final val = double.tryParse(_incomeController.text) ?? 0.0;
                                  _firestoreService.updateIncome(widget.familyId, totalIncome + val);
                                  setState(() => _isEditingIncome = false);
                                },
                                child: const Text("Add"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                ),
                                onPressed: () {
                                  final val = double.tryParse(_incomeController.text) ?? 0.0;
                                  _firestoreService.updateIncome(widget.familyId, val);
                                  setState(() => _isEditingIncome = false);
                                },
                                child: const Text("Update"),
                              ),
                            ],
                          ),
                        ],

                        const Spacer(),

                        if (!_isEditingIncome)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepJungleGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditingIncome = true;
                                _incomeController.text = "";
                              });
                            },
                            child: const Text("Edit"),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // EXPENSE TAB
          if (_selectedIndex == 1) ...[
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
              child: Column(
                children: [
                  // Pie chart
                  Expanded(
                    flex: 4,
                    child: StreamBuilder<List<Expense>>(
                      stream: _firestoreService.getExpenses(widget.familyId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final expenses = _selectedCategoryFilter == null
                            ? snapshot.data!
                            : snapshot.data!.where((e) => e.category == _selectedCategoryFilter).toList();
                        return ExpensePieChart(expenses: expenses);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Expense list
                  Expanded(
                    flex: 6,
                    child: StreamBuilder<List<Expense>>(
                      stream: _firestoreService.getExpenses(widget.familyId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final expenses = _selectedCategoryFilter == null
                            ? snapshot.data!
                            : snapshot.data!.where((e) => e.category == _selectedCategoryFilter).toList();
                        return ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            return ExpenseCard(expense: expenses[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? StreamBuilder<Map<String, dynamic>?>(
              stream: _firestoreService.getIncome(widget.familyId),
              builder: (context, snapshot) {
                final currentIncome = snapshot.data?['income']?.toDouble() ?? 0.0;
                return FloatingActionButton(
                  backgroundColor: AppColors.deepJungleGreen,
                  onPressed: () => _showAddExpenseSheet(currentIncome),
                  child: const Icon(Icons.add, color: Colors.white),
                );
              },
            )
          : null,
    );
  }
}
