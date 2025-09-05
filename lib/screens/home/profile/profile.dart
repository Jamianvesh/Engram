import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro/screens/home/profile/rate_app.dart';
import 'package:pro/screens/home/profile/update_username.dart';

import '/widget/aboutus_button.dart';
import 'change_password.dart';
import 'contact_support.dart';
import 'deleteaccount.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final List<String> emojiOptions = ["😊", "😎", "🤓", "😂", "😍", "🤔", "😇"];

  Future<void> _updateEmoji(String emoji) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({"avatar": emoji});
    }
  }

  void _pickEmoji(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: emojiOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _updateEmoji(emojiOptions[index]);
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    emojiOptions[index],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) => const AboutUsSheet(),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login_register");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final selectedEmoji = data["avatar"] ?? "😊";
        final username = data["username"] ?? "Engram User";
        final email = data["email"] ?? user?.email ?? "No email linked";

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Back"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      selectedEmoji,
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () => _pickEmoji(context),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.blue,
                                        child: const Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                username,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildSettingTile(
                      context,
                      icon: Icons.person,
                      text: "Update Username",
                      onTap: () async {
                        await showUpdateUsernameDialog(context);
                        setState(() {});
                      },
                    ),

                    _buildSettingTile(
                      context,
                      icon: Icons.lock,
                      text: "Change Password",
                      onTap: () {
                        ChangePasswordDialog.show(context);
                      },
                    ),

                    _buildSettingTile(
                      context,
                      icon: Icons.delete,
                      text: "Delete My Account",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const DeleteAccountDialog(),
                        );
                      },
                    ),

                    _buildSettingTile(
                      context,
                      icon: Icons.info,
                      text: "About this App",
                      onTap: _showAboutDialog,
                    ),

                    _buildSettingTile(
                      context,
                      icon: Icons.support,
                      text: "Contact Support",
                      onTap: () => ContactSupport.show(context),
                    ),

                    _buildSettingTile(
                      context,
                      icon: Icons.star_rate,
                      text: "Rate this App",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RateAppPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: TextButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text, style: GoogleFonts.roboto(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
