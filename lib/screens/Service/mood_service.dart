
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Model/mood_entry.dart';

class MoodService {

  final _db = FirebaseFirestore.instance;

  String _todayId(DateTime now) => DateFormat('yyyy-MM-dd').format(now);

  CollectionReference<Map<String, dynamic>> _userMoods(String uid) =>
      _db.collection('users').doc(uid).collection('moods');

  Future<MoodEntry?> getById(String uid, String id) async {
    final doc = await _userMoods(uid).doc(id).get();
    if (!doc.exists) return null;
    return MoodEntry.fromMap(doc.id, doc.data()!);
  }

  Future<void> addOrUpdateToday(String uid, MoodEntry entry) async {
    final ref = _userMoods(uid).doc(entry.id);
    final snap = await ref.get();

    if (snap.exists) {
      final existing = MoodEntry.fromMap(snap.id, snap.data()!);
      // mood lock: allow note update only
      await ref.update({'note': entry.note});
      return;
    }
    await ref.set(entry.toMap());
  }

  Future<void> updateNote(String uid, String id, String note) async {
    await _userMoods(uid).doc(id).update({'note': note});
  }

  Future<List<MoodEntry>> last7(String uid) async {
    final from = DateTime.now().toUtc().subtract(const Duration(days: 7));
    final qs = await _userMoods(uid)
        .where('timestamp', isGreaterThan: from)
        .orderBy('timestamp', descending: true)
        .limit(7)
        .get();
    return qs.docs.map((d) => MoodEntry.fromMap(d.id, d.data())).toList();
  }

  String todayId() => _todayId(DateTime.now());
}