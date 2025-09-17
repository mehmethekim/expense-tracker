import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  final String familyId;
  const SettingsScreen({super.key, required this.familyId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.cambridgeBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Family ID
            const Text(
              "Family ID",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      familyId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackBean,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: familyId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Family ID copied!")),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // User info
            const Text(
              "Logged in as",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? "Unknown user",
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            // Sign out button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.caputMortuum,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', // goes back to AuthGate
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
