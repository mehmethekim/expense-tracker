import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_screen.dart';
import 'family_setup_screen.dart';

class FamilySelectionScreen extends StatefulWidget {
  final List<Map<String, dynamic>> families;

  const FamilySelectionScreen({super.key, required this.families});

  @override
  State<FamilySelectionScreen> createState() => _FamilySelectionScreenState();
}

class _FamilySelectionScreenState extends State<FamilySelectionScreen> {
  List<Map<String, dynamic>> _families = [];

  @override
  void initState() {
    super.initState();
    if (widget.families.isEmpty) {
      _fetchFamilies(); // re-fetch if none provided
    } else {
      _families = widget.families;
    }
  }

  Future<void> _fetchFamilies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userDoc.exists || userDoc.data()?['families'] == null) return;

    final familyIds = List<String>.from(userDoc.data()!['families']);
    final families = <Map<String, dynamic>>[];

    for (final id in familyIds) {
      final famDoc =
          await FirebaseFirestore.instance.collection('families').doc(id).get();
      if (famDoc.exists) {
        families.add({
          "id": id,
          "name": famDoc['name'] ?? "Unnamed Family",
        });
      }
    }

    setState(() {
      _families = families;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Family"),
        backgroundColor: AppColors.cambridgeBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _families.length,
              itemBuilder: (context, index) {
                final family = _families[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      family["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text("ID: ${family["id"]}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(familyId: family["id"]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // 👇 Add/Create family button at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepJungleGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50), // full width
              ),
              icon: const Icon(Icons.group_add),
              label: const Text(
                "Join or Create Family",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FamilySetupScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
