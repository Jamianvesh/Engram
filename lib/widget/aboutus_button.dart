import 'package:flutter/material.dart';

class AboutUsSheet extends StatelessWidget {
  const AboutUsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Engram is your English learning companion — providing "
              "books, stories, grammar lessons, and quizzes to help you "
              "improve your language skills in a fun way.\n\n"
              "🌐 Access learning anywhere, anytime",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),

            const Spacer(),

            const Text(
              "We are on our way to develop this app in a more interactable and user-friendly way ! 🚀",
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            Center(
              child: Text(
                "© 2025 Engram",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
