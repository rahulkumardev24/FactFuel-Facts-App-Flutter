import 'package:flutter/material.dart';

import '../helper/colors.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': AppColors.primary,
      'factCount': 128,
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': AppColors.secondaryDark,
      'factCount': 95,
    },
    {
      'name': 'Technology',
      'icon': Icons.phone_android,
      'color': Colors.orange,
      'factCount': 76,
    },
    {
      'name': 'Nature',
      'icon': Icons.eco,
      'color': Colors.green,
      'factCount': 112,
    },
    {
      'name': 'Psychology',
      'icon': Icons.psychology,
      'color': Colors.purple,
      'factCount': 58,
    },
    {
      'name': 'Space',
      'icon': Icons.rocket_launch,
      'color': Colors.deepPurple,
      'factCount': 84,
    },
    {
      'name': 'Animals',
      'icon': Icons.pets,
      'color': Colors.brown,
      'factCount': 67,
    },
    {
      'name': 'Geography',
      'icon': Icons.public,
      'color': Colors.blue,
      'factCount': 72,
    },
    {
      'name': 'Food',
      'icon': Icons.fastfood,
      'color': Colors.red,
      'factCount': 49,
    },
    {
      'name': 'Health',
      'icon': Icons.health_and_safety,
      'color': Colors.pink,
      'factCount': 63,
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_soccer,
      'color': Colors.amber,
      'factCount': 41,
    },
    {
      'name': 'Art',
      'icon': Icons.palette,
      'color': Colors.deepOrange,
      'factCount': 37,
    },
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (_searchQuery.isEmpty) return categories;
    return categories.where((category) {
      return category['name'].toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
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

          // Categories grid
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
                  return _CategoryCard(
                    name: category['name'],
                    icon: category['icon'],
                    color: category['color'],
                    factCount: category['factCount'],
                    onTap: () {
                      // Navigate to category facts screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CategoryFactsScreen(
                                categoryName: category['name'],
                                categoryColor: category['color'],
                              ),
                        ),
                      );
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

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int factCount;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.factCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$factCount facts',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for the category facts screen
class CategoryFactsScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const CategoryFactsScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: categoryColor.withOpacity(0.2),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with actual fact count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interesting fact about $categoryName #${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is a placeholder fact that would be replaced with real content from your database or API. Each category would show facts specific to that topic.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text(
                        '124',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.bookmark_border, size: 18, color: Colors.grey),
                      const Spacer(),
                      Icon(Icons.share, size: 18, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
