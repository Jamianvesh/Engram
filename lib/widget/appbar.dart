import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'gradientanimation.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return AppBar(
      title: const GradientTitle(),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (user != null)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
              final emoji = data['avatar'] ?? '🙂';

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                ),
              );
            },
          ),
      ],
    );
  }
}
