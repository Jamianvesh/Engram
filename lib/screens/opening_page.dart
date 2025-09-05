import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)], // Blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  Text(
                    "Engram",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.satisfy(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Image.asset("assets/images/logo.jpg", height: 150),

                  const SizedBox(height: 16),

                  Text(
                    "Pocket Library",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                      height: 2.0,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "A modern way to master English.\n"
                    "Build fluency through grammar and stories.\n"
                    "One place for everything(A-Z).",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/login_register',
                        );
                      },
                      icon: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      label: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
