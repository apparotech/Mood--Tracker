import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/Model/mood_entry.dart';
import 'package:mood_tracker/screens/Service/mood_service.dart';

class MoodProvider extends ChangeNotifier {
  final MoodService _moodService = MoodService();
  final _auth = FirebaseAuth.instance; // Firebase Auth instance

  String get uid => _auth.currentUser!.uid; // Current user ka UID
  String? error;
  bool loading = false;

  MoodEntry? today;
  List<MoodEntry> last7 = [];

  String get todayId => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      last7 = await _moodService.last7(uid);
      today = await _moodService.getById(uid, todayId);
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> logToday(MoodType mood, {String? note}) async {
    try {
      final entry = MoodEntry(
        id: todayId,
        mood: mood,
        note: note,
        timestamp: DateTime.now().toUtc(),
      );
      await _moodService.addOrUpdateToday(uid, entry);
      await load();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> editNote(String id, String note) async {
    await _moodService.updateNote(uid, id, note);
    await load();
  }

  // -------- Insights --------
  MoodType? get mostFrequent {
    if (last7.isEmpty) return null;
    final map = <MoodType, int>{};
    for (final e in last7) {
      map[e.mood] = (map[e.mood] ?? 0) + 1;
    }
    return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  double get happyPercent {
    if (last7.isEmpty) return 0;
    final total = last7.length;
    final happy = last7.where((e) => e.mood == MoodType.happy).length;
    return (happy * 100) / total;
  }

  int get longestStreak {
    if (last7.isEmpty) return 0;
    final list = List<MoodEntry>.from(last7)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    int best = 1, curr = 1;
    for (int i = 1; i < list.length; i++) {
      if (list[i].mood == list[i - 1].mood) {
        curr++;
        best = curr > best ? curr : best;
      } else {
        curr = 1;
      }
    }
    return best;
  }

}