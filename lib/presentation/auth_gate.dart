import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/family/family_setup_screen.dart';
import '../presentation/screens/auth/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserFamily(String uid) async {
    final db = FirebaseFirestore.instance;

    final families = await db.collection('families')
        .where('members', arrayContains: uid)
        .limit(1)
        .get();

    if (families.docs.isNotEmpty) {
      return families.docs.first.id; // familyId
    }
    return null;
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
          // Not logged in → go to Login
          return const LoginPage();
        }

        // Logged in → check family membership
        return FutureBuilder<String?>(
          future: _getUserFamily(user.uid),
          builder: (context, familySnapshot) {
            if (familySnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (familySnapshot.hasData && familySnapshot.data != null) {
              // Belongs to a family → go Home
              return const HomeScreen();
            } else {
              // No family → go FamilySetup
              return const FamilySetupScreen();
            }
          },
        );
      },
    );
  }
}
