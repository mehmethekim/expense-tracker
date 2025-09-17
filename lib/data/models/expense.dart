class Expense {
  final String? id; // Firestore document ID
  final double amount;
  final String note;
  final String category;
  final DateTime date;
  final String user;

  Expense({
    this.id,
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'note': note,
      'category': category,
      'date': date.toIso8601String(),
      'user': user,
    };
  }

  factory Expense.fromFirestore(Map<String, dynamic> data, String id) {
    return Expense(
      id: id,
      amount: (data['amount'] ?? 0).toDouble(),
      note: data['note'] ?? '',
      category: data['category'] ?? '',
      date: DateTime.parse(data['date']),
      user: data['user'] ?? 'M',
    );
  }
}
