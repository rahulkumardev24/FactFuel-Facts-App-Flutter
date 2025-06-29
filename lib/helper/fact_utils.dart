import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fact_fuel/helper/my_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constant.dart';
import 'colors.dart';

class FactUtils {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static void shareFact(BuildContext context, String factText) async {
    try {
      final message = "🔥 Did you know?\n\n$factText\n\nDownload FactFuel now and explore more amazing facts!";
      await Share.share(message);
    } catch (e) {
      MyDialogs.myShowSnackBar(context, "Error sharing fact", AppColors.error, AppColors.textPrimary);
    }
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
        // Error toggling favorite
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
        // Error fetching user data
      throw Exception(e);
    }
  }

  /// Submit user feedback with comprehensive device and app data
  /// Returns true if successful, false otherwise
  static Future<bool> submitFeedback({
    required String message,
    required int rating,
    String? email,
    String? category,
  }) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final deviceData = await deviceInfo.deviceInfo;
      final packageInfo = await PackageInfo.fromPlatform();

      // Get current user data if available
      final user = FirebaseAuth.instance.currentUser;

      // Prepare feedback data
      final feedbackData = {
        'message': message,
        'rating': rating,
        'email': email ?? user?.email,
        'userId': user?.uid,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
        'appVersion': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'deviceInfo': deviceData.data,
        'platform': Platform.operatingSystem,
        'platformVersion': Platform.operatingSystemVersion,
      };

      // Submit to Firestore
      await FirebaseFirestore.instance
          .collection('feedbacks')
          .add(feedbackData);

      return true;
    } catch (e) {
      log('Error submitting feedback: $e', name: 'FactUtils');
      return false;
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
