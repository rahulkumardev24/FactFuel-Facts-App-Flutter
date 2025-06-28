import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';

class FactUtils {
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  static Future<void> toggleFavorite(String fact, bool isSaved) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final uid = user.uid;
      final docId = fact.hashCode.toString();

      final userFavRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("favorites")
          .doc(docId);

      final likesRef = FirebaseFirestore.instance
          .collection("likes")
          .doc(docId);

      if (isSaved) {
        await userFavRef.delete();
        await likesRef.update({
          'count': FieldValue.increment(-1),
          'likedBy.$uid': FieldValue.delete(),
        });
      } else {
        await userFavRef.set({'fact': fact});
        final snap = await likesRef.get();

        if (!snap.exists) {
          await likesRef.set({
            'fact': fact,
            'count': 1,
            'likedBy': {uid: true},
          });
        } else {
          await likesRef.update({
            'count': FieldValue.increment(1),
            'likedBy.$uid': true,
          });
        }
      }
    } catch (e) {
      print("Error in toggleFavorite: $e");
    }
  }

  static Stream<DocumentSnapshot> favoriteStatusStream(String fact) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    final uid = user.uid;
    final docId = fact.hashCode.toString();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(docId)
        .snapshots();
  }

  /// get favorites
  static Stream<QuerySnapshot> getSavedFacts() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .snapshots();
  }

  static Future<Map<String, dynamic>?> getDailyFact() async {
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

  static Future<List<Map<String, dynamic>>> getTrendingFacts() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("likes")
            .orderBy("count", descending: true)
            .limit(20)
            .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// fetch current user data
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;

      final doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Submit user feedback with comprehensive device and app data
  static Future<void> submitFeedback({
    required String message,
    required int rating,
    String? email,
    String? category,
    BuildContext? context,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final prefs = await SharedPreferences.getInstance();

      // Prepare feedback data
      final feedbackData = {
        'message': message,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
        'userEmail': email ?? user?.email ?? 'anonymous',
        'userId': user?.uid,
        'userName': user?.displayName,
        'category': category ?? 'general',
        'appVersion': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'deviceModel': deviceInfo.model,
        'deviceBrand': deviceInfo.brand,
        'androidVersion': deviceInfo.version.release,
        'firstLaunchDate': prefs.getString('first_launch_date'),
        'totalLaunches': prefs.getInt('launch_count') ?? 0,
        'platform': 'android', // For iOS: 'ios'
      };

      // Add to feedback collection
      await FirebaseFirestore.instance
          .collection('feedbacks')
          .add(feedbackData);

      // Show success message if context is provided
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanks for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<Map<String, int>> fetchFactCounts() async {
    Map<String, int> counts = {};

    for (var category in AppConstant.categories) {
      final collectionName = category['collection'];
      final name = category['name'];

      if (collectionName != null && name != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection(collectionName)
            .get();

        counts[name] = snapshot.size;
      }
    }
    return counts;
  }

}
