import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/app_constant.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/helper/fact_utils.dart';
import 'package:fact_fuel/helper/my_dialogs.dart';
import 'package:fact_fuel/screens/drawer/trending_screen.dart';
import 'package:fact_fuel/widgets/my_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../helper/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/trending_fact_card.dart';
import 'category_fact_screen.dart';

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String dailyFact = '';

  @override
  void initState() {
    super.initState();
    loadFact();
  }

  bool isOffline = false;

  Future<void> loadFact() async {
    try {
      final factData = await FactUtils.getDailyFact();
      setState(() {
        dailyFact = factData?['fact'] ?? 'No fact found';
        isOffline = false;
      });
    } catch (e) {
      setState(() => isOffline = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,

        /// app bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: CustomAppBar(
            title: "FactFuel",
            icon: Icons.menu_rounded,
            onIconPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),

        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome section
              _buildWelcomeSection(size),
              const SizedBox(height: 24),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  children: [
                    /// Daily featured fact
                    _buildDailyFactCard(dailyFact),
                    const SizedBox(height: 24),

                    /// Categories section
                    _buildCategoriesSection(size),
                    const SizedBox(height: 24),

                    /// trending
                    _buildTrendingSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------- Widgets ------------------- ///

  /// welcome card
  Widget _buildWelcomeSection(Size size) {
    return VxArc(
      arcType: VxArcType.convey,
      height: size.height * 0.02,
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        decoration: BoxDecoration(color: AppColors.primary),
        child: Padding(
          padding: EdgeInsets.only(left: size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Fact Explorer!',
                style: myTextStyle24(fontWeight: FontWeight.bold),
              ),
              Text(
                'Discover amazing facts to fuel your curiosity',
                style: myTextStyle14(textColor: AppColors.background),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// daily fact card
  Widget _buildDailyFactCard(String fact) {
    return Container(
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
                  color: AppColors.background.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Fact of the Day',
                  style: myTextStyle11(textColor: AppColors.textSecondary),
                ),
              ),
              const Spacer(),

              MyIconButton(
                icon: Icons.copy_rounded,
                onTap: () {
                  FactUtils.copyToClipboard(fact).then((_) {
                   MyDialogs.myShowSnackBar(context, "Copied to clipboard", AppColors.success, AppColors.textPrimary);
                  });
                },
              ),
              const SizedBox(width: 8),
              // Favorite Icon with StreamBuilder
              StreamBuilder<DocumentSnapshot>(
                stream: FactUtils.favoriteStatusStream(fact),
                builder: (context, snapshot) {
                  final isSaved = snapshot.data?.exists ?? false;
                  return MyIconButton(
                    icon:
                        isSaved
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                    iconColor: isSaved ? Colors.red : AppColors.iconDark,
                    onTap: () => FactUtils.toggleFavorite(fact, isSaved),
                  );
                },
              ),
              const SizedBox(width: 8),
              MyIconButton(
                icon: Icons.share_rounded,
                onTap: () {
                  FactUtils.shareFact(context, fact);
                },
              ),
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

  Widget _buildCategoriesSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: myTextStyle18(textColor: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: size.height * 0.1,
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
                size: size,
                onTap: () {
                  /// Navigate to category facts screen
                  if (category['name'] == "Science") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "science_facts",
                              backGroundImage:
                                  "lib/assets/images/science_background.jpg",
                              appBarTitle: "Science facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Fun") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "fun_facts",
                              backGroundImage:
                                  "lib/assets/images/smileemoji.jpg",
                              appBarTitle: "Nature facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "History") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "history_facts",
                              backGroundImage: "lib/assets/images/history.jpg",
                              appBarTitle: "History facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Technology") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "technology_facts",
                              backGroundImage:
                                  "lib/assets/images/techonogy_background.jpg",
                              appBarTitle: "Technology facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Nature") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "nature_facts",
                              backGroundImage:
                                  "lib/assets/images/nature_background.jpg",
                              appBarTitle: "Nature facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Space") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "space_facts",
                              backGroundImage:
                                  "lib/assets/images/space_background.jpg",
                              appBarTitle: "Space facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Animals") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "animals_facts",
                              backGroundImage:
                                  "lib/assets/images/animal_background.jpg",
                              appBarTitle: "Animal facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Sports") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "sports_facts",
                              backGroundImage:
                                  "lib/assets/images/sports_background.jpg",
                              appBarTitle: "Sport facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Art") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "art_facts",
                              backGroundImage:
                                  "lib/assets/images/art_background.jpg",
                              appBarTitle: "Art facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Food") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "food_facts",
                              backGroundImage:
                                  "lib/assets/images/food_background.jpg",
                              appBarTitle: "Food facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Health") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "health_facts",
                              backGroundImage:
                                  "lib/assets/images/health_background.jpg",
                              appBarTitle: "Health facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Movies & TV") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "movies_facts",
                              backGroundImage:
                                  "lib/assets/images/movies_background.jpg",
                              appBarTitle: "Movies & TV facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Psychology") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "psychology_facts",
                              backGroundImage:
                                  "lib/assets/images/psychology.jpg",
                              appBarTitle: "Psychology facts",
                            ),
                      ),
                    );
                  } else if (category['name'] == "Geography") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryFactsScreen(
                              collectionName: "psychology_facts",
                              backGroundImage:
                                  "lib/assets/images/geography.jpg",
                              appBarTitle: "Psychology facts",
                            ),
                      ),
                    );
                  }
                },
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
    required Size size,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size.height * 0.07,
            height: size.height * 0.06,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: myTextStyle12(textColor: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Color(0xFFFF6F00),
              highlightColor: Color(0xFFFFF176),

              child: Text('Trending Now', style: myTextStyle18()),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrendingScreen()),
                );
              },
              child: Text(
                'See All',
                style: myTextStyle14(textColor: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Map<String, dynamic>>>(
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
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                final data = trendingFacts[index];
                final fact = data['fact'] ?? '';
                final likes = data['count'] ?? 0;
                return TrendingFactCard(fact: fact, likes: likes.toString());
              },
            );
          },
        ),
      ],
    );
  }
}
