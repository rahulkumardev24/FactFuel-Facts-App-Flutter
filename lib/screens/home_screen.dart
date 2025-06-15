import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/app_constant.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, dynamic>?> getDailyFact() async {
    final prefs = await SharedPreferences.getInstance();

    /// Get today's date
    final today = DateTime.now().toIso8601String().substring(0, 10);

    /// Check if we already stored today
    final lastDate = prefs.getString('last_shown_date');
    int lastIndex = prefs.getInt('last_fact_index') ?? 0;

    /// Fetch all facts from Firestore
    final snapshot =
        await FirebaseFirestore.instance.collection('facts_of_day').get();
    final allFacts = snapshot.docs;

    if (allFacts.isEmpty) return null;

    /// If date changed, increment index
    if (lastDate != today) {
      lastIndex = (lastIndex + 1) % allFacts.length;
      await prefs.setString('last_shown_date', today);
      await prefs.setInt('last_fact_index', lastIndex);
    }

    return allFacts[lastIndex].data();
  }

  String dailyFact = '';

  @override
  void initState() {
    super.initState();
    loadFact();
  }

  Future<void> loadFact() async {
    final factData = await getDailyFact();
    setState(() {
      dailyFact = factData?['fact'] ?? 'No fact found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,

        /// app bar
        appBar: AppBar(
          title: Text(
            'FactFuel',
            style: myTextStyle21(
              fontWeight: FontWeight.bold,
              textColor: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32)),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: AppColors.textPrimary,
            ),
          ],
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),

        drawer: Drawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              /// Daily featured fact
              _buildDailyFactCard(dailyFact),
              const SizedBox(height: 24),

              /// Categories section
              _buildCategoriesSection(),
              const SizedBox(height: 24),

              // Trending facts
              _buildTrendingSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------- Widgets ------------------- ///

  /// welcome card
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Fact Explorer!',
          style: myTextStyle21(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Discover amazing facts to fuel your curiosity',
          style: myTextStyle14(textColor: Colors.black45),
        ),
      ],
    );
  }

  /// daily fact card
  Widget _buildDailyFactCard(String fact) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent.shade100, Colors.orangeAccent.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Fact of the Day',
                  style: myTextStyle11(textColor: Colors.white70),
                ),
              ),
              const Spacer(),
              const Icon(Icons.copy, color: Colors.black45, size: 20),
              const SizedBox(width: 8),
              const Icon(
                Icons.favorite_border,
                color: Colors.black45,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.share, color: Colors.black45, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            fact,
            style: myTextStyle16(
              textColor: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daily • 1 min read',
            style: myTextStyle11(textColor: Colors.black.withAlpha(160)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: myTextStyle18()),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstant.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = AppConstant.categories[index];
              return _buildCategoryItem(
                icon: category['icon'],
                name: category['name'],
                color: category['color'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String name,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    final trendingFacts = [
      {
        'title': 'Octopuses have three hearts',
        'category': 'Nature',
        'likes': '1.2k',
      },
      {
        'title': 'The shortest war lasted 38 minutes',
        'category': 'History',
        'likes': '890',
      },
      {
        'title': 'Bananas are berries, strawberries aren\'t',
        'category': 'Food',
        'likes': '2.4k',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Trending Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: trendingFacts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final fact = trendingFacts[index];
            return _buildTrendingFactCard(
              title: fact['title'] as String,
              category: fact['category'] as String,
              likes: fact['likes'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrendingFactCard({
    required String title,
    required String category,
    required String likes,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    likes,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
