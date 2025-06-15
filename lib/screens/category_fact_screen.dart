import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/colors.dart';

class CategoryFactsScreen extends StatefulWidget {
  String collectionName;
  String backGroundImage;
  String appBarTitle;
  CategoryFactsScreen({
    super.key,
    required this.collectionName,
    required this.backGroundImage,
    required this.appBarTitle,
  });

  @override
  State<CategoryFactsScreen> createState() => _CategoryFactsScreenState();
}

class _CategoryFactsScreenState extends State<CategoryFactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: myTextStyle18(textColor: Colors.white54),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(widget.backGroundImage, fit: BoxFit.cover),
            ),
          ),
          Container(color: Colors.black45),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection(widget.collectionName)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Data is Empty"));
              }
              final myData = snapshot.data!.docs;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myData.length,
                    itemBuilder: (context, index) {
                      final facts =
                          myData[index].data() as Map<String, dynamic>;
                      return Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                facts['fact'] ?? "No Facts",
                                style: myTextStyle16(),
                              ),
                              const SizedBox(height: 12),

                              /// fav button
                              /// ---> add to fav button
                              Row(
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            )
                                            .collection("favorites")
                                            .doc(facts['fact'])
                                            .snapshots(),
                                    builder: (context, favSnapshot) {
                                      bool isSaved =
                                          favSnapshot.data?.exists ?? false;

                                      return GestureDetector(
                                        onTap: () async {
                                          final favRef = FirebaseFirestore
                                              .instance
                                              .collection("users")
                                              .doc(
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                              )
                                              .collection("favorites")
                                              .doc(facts['fact']);

                                          if (isSaved) {
                                            await favRef.delete();
                                          } else {
                                            await favRef.set({
                                              'fact': facts['fact'],
                                            });
                                          }
                                        },
                                        child: Icon(
                                          isSaved
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 18,
                                          color:
                                              isSaved
                                                  ? Colors.red
                                                  : Colors.black45,
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(width: 16),

                                  /// Copy icon with onTap to copy the text
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: facts['fact'] ?? "No Facts",
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Copied to clipboard"),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      size: 18,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.share,
                                    size: 18,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
