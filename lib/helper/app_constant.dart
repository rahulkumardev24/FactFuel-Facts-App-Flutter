import 'package:flutter/material.dart';

import 'colors.dart';

class AppConstant {
  static List<Map<String, dynamic>> categories = [
    {
      'name': 'Science',
      'icon': Icons.science,
      'color': AppColors.primary,
      'collection': 'science_facts',
    },
    {
      'name': 'Fun',
      'icon': Icons.emoji_emotions_rounded,
      'color': Colors.yellow,
      'collection': 'fun_facts',
    },
    {
      'name': 'History',
      'icon': Icons.history_edu,
      'color': AppColors.secondaryDark,
      'collection': 'history_facts',
    },
    {
      'name': 'Technology',
      'icon': Icons.phone_android,
      'color': Colors.orange,
      'collection': 'technology_facts',
    },
    {
      'name': 'Nature',
      'icon': Icons.eco,
      'color': Colors.green,
      'collection': 'nature_facts',
    },
    {
      'name': 'Psychology',
      'icon': Icons.psychology,
      'color': Colors.purple,
      'collection': 'psychology_facts',
    },
    {
      'name': 'Space',
      'icon': Icons.rocket_launch,
      'color': Colors.deepPurple,
      'collection': 'space_facts',
    },
    {
      'name': 'Animals',
      'icon': Icons.pets,
      'color': Colors.brown,
      'collection': 'animals_facts',
    },
    {
      'name': 'Geography',
      'icon': Icons.public,
      'color': Colors.blue,
      'collection': 'geography_facts',
    },
    {
      'name': 'Food',
      'icon': Icons.fastfood,
      'color': Colors.red,
      'collection': 'food_facts',
    },
    {
      'name': 'Health',
      'icon': Icons.health_and_safety,
      'color': Colors.pink,
      'collection': 'health_facts',
    },
    {
      'name': 'Sports',
      'icon': Icons.sports_soccer,
      'color': Colors.amber,
      'collection': 'sports_facts',
    },
    {
      'name': 'Art',
      'icon': Icons.palette,
      'color': Colors.deepOrange,
      'collection': 'art_facts',
    },

    {
      'name': 'Movies & TV',
      'icon': Icons.movie,
      'color': Colors.cyan,
      'collection': 'movies_facts',
    },

  ];

}
