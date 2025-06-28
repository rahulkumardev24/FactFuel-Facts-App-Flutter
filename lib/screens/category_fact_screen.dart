import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import '../helper/colors.dart';
import '../widgets/categories_fact_card.dart';

class CategoryFactsScreen extends StatefulWidget {
  final String collectionName;
  final String backGroundImage;
  final String appBarTitle;
  
  const CategoryFactsScreen({
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
          style: myTextStyle18(textColor: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// background image
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: 0.9,
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myData.length,
                  itemBuilder: (context, index) {
                    final facts = myData[index].data() as Map<String, dynamic>;

                    /// call Categories Fact Card
                    return CategoriesFactCard(
                      fact: facts['fact'] ?? "No Facts",
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
