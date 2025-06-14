import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../helper/colors.dart';

class CategoryFactsScreen extends StatefulWidget {
  String collectionName;
  CategoryFactsScreen({super.key, required this.collectionName});

  @override
  State<CategoryFactsScreen> createState() => _CategoryFactsScreenState();
}

class _CategoryFactsScreenState extends State<CategoryFactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myData.length,
            itemBuilder: (context, index) {
              final facts = myData[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(facts['fact'] ?? "No Facts", style: myTextStyle16()),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.copy, size: 18, color: Colors.grey),
                          const Spacer(),
                          Icon(Icons.share, size: 18, color: Colors.grey),
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
    );
  }
}
