import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/fact_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/custom_text_style.dart';
import '../helper/colors.dart';
import '../widgets/saved_fact_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedFactsScreenState();
}

class _SavedFactsScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      /// app bar
      appBar: AppBar(
        title: Text(
          "Saved Facts",
          style: myTextStyle21(textColor: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FactUtils.getSavedFacts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                /// no item saved then
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/icons/no_facts.png',
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Favorites Yet',
                        style: myTextStyle21(
                          textColor: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              /// data
              final savedFacts = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedFacts.length,
                itemBuilder: (context, index) {
                  final factData =
                      savedFacts[index].data() as Map<String, dynamic>;
                  final fact = factData['fact'] ?? "No Fact";

                  return SavedFactCard(fact: fact, );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
