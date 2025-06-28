import 'package:fact_fuel/helper/fact_utils.dart';
import 'package:flutter/material.dart';
import '../../helper/colors.dart';
import '../../helper/custom_text_style.dart';
import '../../widgets/trending_fact_card.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingFactsScreenState();
}

class _TrendingFactsScreenState extends State<TrendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// app bar
      appBar: AppBar(
        title: Text(
          "Trending Facts",
          style: myTextStyle18(textColor: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0 , left: 12.0 , top: 12),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: FactUtils.getTrendingFacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No trending facts yet.");
                }
                final trendingFacts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: trendingFacts.length,
                  itemBuilder: (context, index) {
                    final data = trendingFacts[index];
                    final fact = data['fact'] ?? '';
                    final likes = data['count'] ?? 0;
                    return TrendingFactCard(fact: fact, likes: likes.toString());
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
