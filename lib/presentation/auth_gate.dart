import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/family/family_setup_screen.dart';
import '../presentation/screens/family/family_selection_screen.dart';
import '../presentation/screens/auth/login_page.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Stream<List<Map<String, dynamic>>?> _userFamiliesStream(String uid) async* {
    final db = FirebaseFirestore.instance;

    await for (final snap in db.collection('users').doc(uid).snapshots()) {
      if (!snap.exists) {
        // User doc not created yet → return null (still loading)
        yield null;
        continue;
      }

      final data = snap.data();
      final familyIds = List<String>.from(data?['families'] ?? []);
      final families = <Map<String, dynamic>>[];

      for (final id in familyIds) {
        final famDoc = await db.collection('families').doc(id).get();
        if (famDoc.exists) {
          families.add({
            "id": id,
            "name": famDoc['name'] ?? "Unnamed Family",
          });
        }
      }

      yield families;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        return StreamBuilder<List<Map<String, dynamic>>?>(
          stream: _userFamiliesStream(user.uid),
          builder: (context, familySnap) {
            if (familySnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final families = familySnap.data;

            if (families == null) {
              // ✅ User doc not ready yet → still loading
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (families.isEmpty) {
              // ✅ User doc exists, but no families → go to Setup
              return const FamilySetupScreen();
            } else if (families.length == 1) {
              // ✅ One family → direct to Home
              return HomeScreen(familyId: families.first["id"]);
            } else {
              // ✅ Multiple families → let user choose
              return FamilySelectionScreen(families: families);
            }
          },
        );
      },
    );
  }
}

