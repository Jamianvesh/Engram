import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro/widget/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class GrammarDetailPage extends StatelessWidget {
  final String grammarId;
  final String title;

  const GrammarDetailPage({
    Key? key,
    required this.grammarId,
    required this.title,
  }) : super(key: key);

  Future<void> _openYoutube(String url) async {
    final Uri youtubeAppUrl = Uri.parse(
      url.replaceFirst("https://www.youtube.com/watch?v=", "vnd.youtube:"),
    );
    final Uri youtubeWebUrl = Uri.parse(url);

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Quiz questions coming soon!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: const CustomAppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("grammar_topics")
              .doc(grammarId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading data"));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No data available"));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data == null || data.isEmpty) {
              return const Center(child: Text("No data available"));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        data["Title"] ?? title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (data["description"] != null)
                        Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              data["description"],
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ),

                      if (data["video Url"] != null)
                        Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(
                              Icons.play_circle_fill,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Watch on YouTube",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => _openYoutube(data["video Url"]),
                          ),
                        ),
                    ],
                  ),
                ),

                // Sticky Quiz Button
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () => _showComingSoon(context),
                      icon: const Icon(Icons.quiz, color: Colors.white),
                      label: Text(
                        "Take Quiz",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
