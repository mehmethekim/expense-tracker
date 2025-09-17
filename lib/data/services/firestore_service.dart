import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import 'dart:math';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔑 Generate unique family ID like XXXX-XXXX
  String generateFamilyId() {
    final rand = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[rand.nextInt(chars.length)];
      if (i == 3) code += '-'; // XXXX-XXXX
    }
    return code;
  }

  // 📌 Add user to a family (multi-family support)
  Future<void> addUserToFamily(String userId, String familyId) async {
    await _db.collection("users").doc(userId).set({
      "families": FieldValue.arrayUnion([familyId]),
    }, SetOptions(merge: true));
  }

  // 📌 Fetch all families a user belongs to
  Future<List<String>> getUserFamilies(String userId) async {
    final doc = await _db.collection("users").doc(userId).get();
    if (!doc.exists) return [];
    final data = doc.data();
    if (data == null || data["families"] == null) return [];
    return List<String>.from(data["families"]);
  }

  // 📌 Fetch family details (name + id) for a list of familyIds
  Future<List<Map<String, dynamic>>> getFamilyDetails(List<String> familyIds) async {
    final families = <Map<String, dynamic>>[];
    for (final id in familyIds) {
      final doc = await _db.collection("families").doc(id).get();
      if (doc.exists) {
        families.add({
          "id": id,
          "name": doc["name"],
        });
      }
    }
    return families;
  }

  // 📌 Create family and register user
  Future<String> createFamily(String familyName, String userId) async {
    final familyId = generateFamilyId();
    await _db.collection('families').doc(familyId).set({
      'name': familyName,
      'members': [userId],
      'income': 0,
    });

    // Reverse mapping → user → family
    await addUserToFamily(userId, familyId);

    return familyId;
  }

  // 📌 Join existing family
  Future<bool> joinFamily(String familyId, String userId) async {
    final doc = await _db.collection('families').doc(familyId).get();
    if (!doc.exists) return false;

    await _db.collection('families').doc(familyId).update({
      'members': FieldValue.arrayUnion([userId]),
    });

    await addUserToFamily(userId, familyId);
    return true;
  }

  // 📌 Add a new expense under a family
  Future<void> addExpense(String familyId, Expense expense) async {
    await _db
        .collection("families")
        .doc(familyId)
        .collection("expenses")
        .add(expense.toMap());
  }

  // 📌 Update an existing expense
  Future<void> updateExpense(String familyId, String expenseId, Expense updatedExpense) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('expenses')
        .doc(expenseId)
        .update(updatedExpense.toMap());
  }

  // 📌 Get expenses as a stream (real-time updates)
  Stream<List<Expense>> getExpenses(String familyId) {
    return _db
        .collection("families")
        .doc(familyId)
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Expense(
          id: doc.id, // keep Firestore id for editing
          amount: (data["amount"] as num).toDouble(),
          note: data["note"],
          category: data["category"],
          user: data["user"],
          date: DateTime.parse(data["date"]),
        );
      }).toList();
    });
  }

  // 📌 Update (overwrite) family income
  Future<void> updateIncome(String familyId, double newIncome) async {
    await _db
        .collection("families")
        .doc(familyId)
        .set({"income": newIncome}, SetOptions(merge: true));
  }

  // 📌 Get family income as a stream
  Stream<Map<String, dynamic>?> getIncome(String familyId) {
    return _db
        .collection("families")
        .doc(familyId)
        .snapshots()
        .map((doc) => doc.data());
  }

  // 📌 Ensure family doc exists (safety net)
  Future<void> ensureFamilyExists(String familyId) async {
    final docRef = _db.collection("families").doc(familyId);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({"income": 0});
    }
  }
}
