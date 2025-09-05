import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateAppPage extends StatefulWidget {
  const RateAppPage({Key? key}) : super(key: key);

  @override
  State<RateAppPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<RateAppPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;
  String? _latestFeedbackId;

  @override
  void initState() {
    super.initState();
    _selectedRating = 0;
    _commentController.clear();
  }

  Future<void> _submitFeedback() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final ref = await FirebaseFirestore.instance.collection("feedback").add({
        "userId": user!.uid,
        "rating": _selectedRating,
        "comment": _commentController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(),
      });

      _latestFeedbackId = ref.id;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );

      setState(() {
        _selectedRating = 0;
        _commentController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildAverageRating() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("feedback").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(color: Colors.white);
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Text(
            "No ratings yet",
            style: TextStyle(color: Colors.white),
          );
        }

        double total = 0;
        int count = 0;
        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data["rating"] != null) {
            total += data["rating"];
            count++;
          }
        }
        double average = total / count;

        return Column(
          children: [
            Text(
              "Average Rating: ${average.toStringAsFixed(1)} ⭐",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "$count rating${count > 1 ? 's' : ''}",
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("feedback")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const SizedBox();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final feedbackId = docs[index].id;
            final comment = data["comment"] ?? "";
            final rating = data["rating"] ?? 0;
            final userId = data["userId"] ?? "";

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: comment.isNotEmpty
                    ? Text(comment, style: GoogleFonts.roboto(fontSize: 14))
                    : null,
                subtitle: Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.yellow[700],
                    ),
                  ),
                ),
                trailing:
                    (userId == user?.uid && _latestFeedbackId == feedbackId)
                    ? IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _editCommentDialog(feedbackId, comment),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  void _editCommentDialog(String feedbackId, String oldText) {
    final TextEditingController _editController = TextEditingController(
      text: oldText,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: _editController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Update your comment",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newText = _editController.text.trim();
              if (newText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection("feedback")
                    .doc(feedbackId)
                    .update({
                      "comment": newText,
                      "timestamp": FieldValue.serverTimestamp(),
                    });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Comment updated")),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42A5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rate this App",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAverageRating(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Feedback",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () {
                            setState(() => _selectedRating = index + 1);
                          },
                          icon: Icon(
                            index < _selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Write your comment...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Other Feedbacks",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildFeedbackList(),
            ],
          ),
        ),
      ),
    );
  }
}
