import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/custom_text_style.dart';
import '../helper/colors.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedFactsScreenState();
}

class _SavedFactsScreenState extends State<SavedScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Facts",
          style: myTextStyle18(textColor: Colors.white54),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,

      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black45,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("favorites")
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No favorites yet."));
                }

                final savedFacts = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: savedFacts.length,
                  itemBuilder: (context, index) {
                    final factData =
                        savedFacts[index].data() as Map<String, dynamic>;
                    final fact = factData['fact'] ?? "No Fact";

                    return Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fact, style: myTextStyle16()),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: fact),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Copied to clipboard"),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.black45,
                                    size: 18,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    savedFacts[index].reference.delete();
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
