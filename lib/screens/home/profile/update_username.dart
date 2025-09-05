import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> showUpdateUsernameDialog(BuildContext context) async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Update Username"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: "Enter new username"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final newName = controller.text.trim();

            if (newName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Username cannot be empty")),
              );
              return;
            }

            if (newName.length > 12) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Username must be ≤ 12 characters"),
                ),
              );
              return;
            }

            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await user.updateDisplayName(newName);

              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .update({"username": newName});
            }

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Username updated successfully")),
            );
          },
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
