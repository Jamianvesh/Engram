import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'story_detail_page.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildStories(String category) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("story_categories")
          .doc(category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No stories available"));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final storyKeys = data.keys.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: storyKeys.length,
          itemBuilder: (context, index) {
            String storyKey = storyKeys[index];
            Map<String, dynamic> storyData =
                data[storyKey] as Map<String, dynamic>;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(
                  storyKey,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                subtitle: Text(
                  storyData.keys.first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailPage(
                        title: storyData.keys.first,
                        story: storyData[storyData.keys.first]["story"],
                        moral: storyData[storyData.keys.first]["moral"],
                        youtube:
                            storyData[storyData.keys.first]["youTube Link"],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue.shade100,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue.shade800,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue.shade800,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: "Easy"),
              Tab(text: "Medium"),
              Tab(text: "Hard"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStories("easy"),
              _buildStories("medium"),
              _buildStories("hard"),
            ],
          ),
        ),
      ],
    );
  }
}
