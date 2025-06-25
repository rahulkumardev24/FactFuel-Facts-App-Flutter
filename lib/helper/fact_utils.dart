import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FactUtils {
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

/*
  static Future<void> toggleFavorite(String fact, bool isSaved) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docId = fact.hashCode.toString();
      final favRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("favorites")
          .doc(docId);

      if (isSaved) {
        await favRef.delete();
      } else {
        await favRef.set({'fact': fact});
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }
*/


  static Future<void> toggleFavorite(String fact, bool isSaved) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
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
        /// UNLIKE: Remove from favorites and update global likes count
        await userFavRef.delete();

        await likesRef.update({
          'count': FieldValue.increment(-1),
          'likedBy.$uid': FieldValue.delete(),
        });
      } else {
        /// LIKE: Save to favorites and update global likes count
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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docId = fact.hashCode.toString(); // match toggleFavorite()
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites")
        .doc(docId)
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
    final snapshot = await FirebaseFirestore.instance
        .collection("likes")
        .orderBy("count", descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }


}
