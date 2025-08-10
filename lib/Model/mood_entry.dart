

enum MoodType { happy, sad, angry, neutral }

extension MoodTypeExtension on MoodType {
  String get name {
    switch (this) {
      case MoodType.happy: return 'Happy 😀';
      case MoodType.sad: return 'Sad 😢';
      case MoodType.angry: return 'Angry 😡';
      case MoodType.neutral: return 'Neutral 😌';
    }
  }
}

class MoodEntry {
  final String id;            // yyyy-MM-dd
  final MoodType mood;
  final String? note;
  final DateTime timestamp;

  MoodEntry({required this.id, required this.mood, this.note, required this.timestamp});

  Map<String, dynamic> toMap() => {
    'mood': mood.name,
    'note': note,
    'timestamp': timestamp.toUtc(),
  };

  factory MoodEntry.fromMap(String id, Map<String, dynamic> m) => MoodEntry(
    id: id,
    mood: MoodType.values.firstWhere((e) => e.name == (m['mood'] ?? 'neutral'), orElse: () => MoodType.neutral),
    note: (m['note'] as String?)?.trim(),
    timestamp: DateTime.tryParse(m['timestamp']?.toString() ?? '') ?? DateTime.now().toUtc(),
  );
}
