import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro/widget/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryDetailPage extends StatelessWidget {
  final String title;
  final String story;
  final String moral;
  final String youtube;

  const StoryDetailPage({
    super.key,
    required this.title,
    required this.story,
    required this.moral,
    required this.youtube,
  });

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
        appBar: CustomAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Story Section
                  Text(
                    "Story",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        story,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),

                  // Moral Section
                  Text(
                    "Moral",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        moral,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),

                  // YouTube Section
                  Text(
                    "Watch on YouTube",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        minimumSize: Size.zero,
                        // ensures it stays compact
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // no extra padding
                      ),
                      onPressed: () => _openYoutube(youtube),
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 18,
                        color: Colors.red,
                      ),
                      label: Text(
                        "YouTube",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
