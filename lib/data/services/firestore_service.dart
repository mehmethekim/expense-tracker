import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import 'dart:math';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Generate unique family ID like XXXX-XXXX
  String generateFamilyId() {
    final rand = Random();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[rand.nextInt(chars.length)];
      if (i == 3) code += '-'; // XXXX-XXXX
    }
    return code;
  }

  Future<String> createFamily(String familyName, String userId) async {
    final familyId = generateFamilyId();
    await _db.collection('families').doc(familyId).set({
      'name': familyName,
      'members': [userId],
      'income': 0,
    });
    return familyId;
  }
  Future<bool> joinFamily(String familyId, String userId) async {
    final doc = await _db.collection('families').doc(familyId).get();
    if (!doc.exists) return false;

    await _db.collection('families').doc(familyId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
    return true;
  }
  /// Add a new expense under a family
  Future<void> addExpense(String familyId, Expense expense) async {
    await _db.collection("families")
        .doc(familyId)
        .collection("expenses")
        .add({
          "amount": expense.amount,
          "note": expense.note,
          "category": expense.category,
          "user": expense.user,
          "date": expense.date.toIso8601String(),
        });
  }

  /// Get expenses as a live stream
  Stream<List<Expense>> getExpenses(String familyId) {
    return _db.collection("families")
        .doc(familyId)
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense(
              amount: (doc["amount"] as num).toDouble(),
              note: doc["note"],
              category: doc["category"],
              user: doc["user"],
              date: DateTime.parse(doc["date"]),
            )).toList()
        );
  }

  /// Update (overwrite or increment) family income
  Future<void> updateIncome(String familyId, double newIncome) async {
    await _db.collection("families")
        .doc(familyId)
        .set({
          "income": newIncome,
        }, SetOptions(merge: true));
  }

  /// Get family income as a stream
  Stream<Map<String, dynamic>?> getIncome(String familyId) {
    return _db.collection("families")
        .doc(familyId)
        .snapshots()
        .map((doc) => doc.data());
  }
  Future<void> ensureFamilyExists(String familyId) async {
  final docRef = _db.collection("families").doc(familyId);
  final doc = await docRef.get();
  if (!doc.exists) {
    await docRef.set({"income": 0});
  }
}
}
