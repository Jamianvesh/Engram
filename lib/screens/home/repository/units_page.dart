import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro/widget/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UnitsPage extends StatelessWidget {
  final int classNumber;

  const UnitsPage({Key? key, required this.classNumber}) : super(key: key);

  int _extractNumber(String name) {
    final match = RegExp(r'\d+').firstMatch(name);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  Future<void> _openTextbook(String url) async {
    final Uri docsUrl = Uri.parse(
      "https://docs.google.com/gview?embedded=true&url=$url",
    );
    if (await canLaunchUrl(docsUrl)) {
      await launchUrl(docsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open textbook link";
    }
  }

  Future<void> _openYoutube(String url) async {
    final Uri youtubeAppUrl = Uri.parse(
      url.replaceFirst("https://www.youtube.com/watch?v=", "vnd.youtube:"),
    );
    final Uri youtubeWebUrl = Uri.parse(url);

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch YouTube link";
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
        appBar: const CustomAppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("class_resources")
              .doc("Class $classNumber")
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

            final sortedUnits = data.entries.toList()
              ..sort(
                (a, b) =>
                    _extractNumber(a.key).compareTo(_extractNumber(b.key)),
              );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: sortedUnits.map((unitEntry) {
                final unitName = unitEntry.key;
                final chapters = unitEntry.value as Map<String, dynamic>;

                final sortedChapters = chapters.entries.toList()
                  ..sort(
                    (a, b) =>
                        _extractNumber(a.key).compareTo(_extractNumber(b.key)),
                  );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unitName,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...sortedChapters.map((chapterEntry) {
                      final chapterName = chapterEntry.key;
                      final chapterData =
                          chapterEntry.value as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapterData["Title"] ?? chapterName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (chapterData["Textbook"] != null)
                                ListTile(
                                  leading: const Icon(
                                    Icons.menu_book,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    "Textbook",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () =>
                                      _openTextbook(chapterData["Textbook"]),
                                ),
                              if (chapterData["Youtube link"] != null)
                                ListTile(
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
                                  onTap: () =>
                                      _openYoutube(chapterData["Youtube link"]),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
