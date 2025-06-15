import 'package:fact_fuel/helper/app_constant.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// app bar
      appBar: AppBar(
        title: Text('Categories', style: myTextStyle18()),
        backgroundColor: AppColors.surface,
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
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
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
                    factCount: category['factCount'],
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
                      } else if (category['name'] == "History") {
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
    super.dispose();
  }
}
