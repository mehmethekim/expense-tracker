class Expense {
  final double amount;
  final String note;
  final String category;
  final DateTime date;
  final String user; // "Ş" or "M"

  Expense({
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
    required this.user,
  });
}
