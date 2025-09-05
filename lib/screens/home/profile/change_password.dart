import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog {
  static Future<void> show(BuildContext context) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user == null) return;

    bool _isValidPassword(String password) {
      final regex = RegExp(r'^(?=.*[a-z])(?=.*[0-9]).{6,}$');
      return regex.hasMatch(password);
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Update",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                final currentPassword = currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();

                if (currentPassword.isEmpty || newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill both fields")),
                  );
                  return;
                }

                if (currentPassword == newPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Give a new password")),
                  );
                  return;
                }

                if (!_isValidPassword(newPassword)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password must contain at least 6 characters, one lowercase letter, and one number",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(cred);

                  await user.updatePassword(newPassword);

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password updated successfully ✅"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
