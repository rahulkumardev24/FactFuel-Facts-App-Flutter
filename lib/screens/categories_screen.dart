import 'package:fact_fuel/helper/app_constant.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/colors.dart';
import '../helper/fact_utils.dart';
import '../widgets/categories_card.dart';
import 'category_fact_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// filter -> Search
  List<Map<String, dynamic>> get filteredCategories {
    if (_searchQuery.isEmpty) return AppConstant.categories;
    return AppConstant.categories.where((category) {
      return category['name'].toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
    }).toList();
  }

  Map<String, int> _factCounts = {};

  @override
  void initState() {
    super.initState();
    loadFactCounts();
  }

  Future<void> loadFactCounts() async {
    try {
      final counts = await FactUtils.fetchFactCounts();
      if (mounted) {
        setState(() {
          _factCounts = counts;
        });
      }
    } catch (e) {
      if (mounted) {
        // Handle error if needed
        debugPrint('Error loading fact counts: $e');
      }
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset status bar when returning to this screen
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// app bar
      appBar: AppBar(
        title: Text(
          'Categories',
          style: myTextStyle21(textColor: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      /// body
      body: Column(
        children: [
          /// Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: myTextStyle16(textColor: AppColors.textSecondary),
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                hintStyle: myTextStyle14(textColor: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.primaryLight.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          /// Categories grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return CategoryCard(
                    name: category['name'],
                    icon: category['icon'],
                    color: category['color'],
                    factCount: _factCounts[category['name']] ?? 0 ,
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
                      }else if (category['name'] == "Fun") {
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
                      }
                      else if (category['name'] == "History") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CategoryFactsScreen(
                                  collectionName: "history_facts",
                                  backGroundImage:
                                      "lib/assets/images/history.jpg",
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
                      }else if (category['name'] == "Psychology") {
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
                      }else if (category['name'] == "Geography") {
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    /// Cancel any pending async operations
    super.dispose();
  }
}
