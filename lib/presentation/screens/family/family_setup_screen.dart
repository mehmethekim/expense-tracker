import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/firestore_service.dart';
import '../home/home_screen.dart';

class FamilySetupScreen extends StatefulWidget {
  const FamilySetupScreen({super.key});

  @override
  State<FamilySetupScreen> createState() => _FamilySetupScreenState();
}

class _FamilySetupScreenState extends State<FamilySetupScreen> {
  final _familyNameController = TextEditingController();
  final _familyIdController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  Future<void> _createFamily() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final familyId = await _firestoreService.createFamily(
        _familyNameController.text,
        user.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Family created! ID: $familyId")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _joinFamily() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final success = await _firestoreService.joinFamily(
        _familyIdController.text.trim(),
        user.uid,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Joined family successfully!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Family ID not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintCream,
      appBar: AppBar(
        title: const Text("Family Setup"),
        backgroundColor: AppColors.cambridgeBlue,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Create Family
                  TextField(
                    controller: _familyNameController,
                    decoration: const InputDecoration(
                      labelText: "Family Name",
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepJungleGreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _createFamily,
                    child: const Text("Create Family"),
                  ),

                  const SizedBox(height: 40),

                  // Join Family
                  TextField(
                    controller: _familyIdController,
                    decoration: const InputDecoration(
                      labelText: "Enter Family ID",
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.caputMortuum,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _joinFamily,
                    child: const Text("Join Family"),
                  ),
                ],
              ),
            ),
    );
  }
}
