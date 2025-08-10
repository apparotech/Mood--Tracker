import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/core/utils/ui_helpers.dart';
import 'package:mood_tracker/screens/providers/mood_provider.dart';
import 'package:provider/provider.dart';

import '../Model/mood_entry.dart';
class MoodLogScreen extends StatefulWidget {
  const MoodLogScreen({super.key});

  @override
  State<MoodLogScreen> createState() => _MoodLogScreenState();
}

class _MoodLogScreenState extends State<MoodLogScreen> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final mp = context.read<MoodProvider?>();
      mp?.load();
    });
  }

  void _saveNote() {
    final mp = context.read<MoodProvider?>();
    if (mp == null) return;

    final text = _noteController.text.trim();
    final id = mp.today?.id ?? mp.todayId;

    if (text.isEmpty) {
      showAppSnack(context, message: "Note cannot be empty!");

      return;
    }

    if (mp.today != null) {
      mp.editNote(id, text);
      _noteController.clear();
      showAppSnack(context, message: "Note saved successfully!");
    } else {
      showAppSnack(context, message: "Pick a mood first");

    }
  }

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MoodProvider?>();
    if (mp == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Today\'s Mood',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: mp.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: MoodType.values.map((m) {
                final isLocked = mp.today != null;
                final isSelected = mp.today?.mood == m;

                return ChoiceChip(
                  label: Text(
                    m.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.blue.shade900,
                      fontWeight: FontWeight.w700,
                      shadows: isSelected
                          ? [
                        Shadow(
                          blurRadius: 2,
                          offset: Offset(0.5, 0.5),
                          color:
                          Colors.black.withOpacity(0.3),
                        )
                      ]
                          : [],
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.blue.shade500,
                    width: 1.8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  onSelected:
                  isLocked ? null : (_) => mp.logToday(m),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add note ',
                labelStyle: TextStyle(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.edit_note, color: Colors.blue.shade600),
                filled: true,
                fillColor: Colors.blue.shade50, // light blue background
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                ),
              ),

              textInputAction: TextInputAction.done,
              onSubmitted: (text) {
                final id = mp.today?.id ?? mp.todayId;
                if (mp.today != null) {
                  mp.editNote(id, text);
                  //showAppSnack
                  showAppSnack(context, message: "Note saved successfully!");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Pick a mood first')),
               );
               }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                 _saveNote();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Note",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white),
                ),
              ),
            ),





          ],
        ),
      ),
    );
  }
}
