import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mood_tracker/Model/mood_entry.dart';        // <-- MoodType enum
import 'package:mood_tracker/screens/providers/mood_provider.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MoodProvider?>();
    if (mp == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
            'Last 7 Days', style: TextStyle(
           fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
      ),


      body: mp.last7.isEmpty
      ? _EmptyHistory(onRefresh: () async => await mp.load())

      : RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async => await mp.load(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: mp.last7.length,
          itemBuilder: (_, i) {
            final e = mp.last7[i];
            final c = _moodColor(e.mood); // <-- color for this mood

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            margin: const EdgeInsets.symmetric(vertical: 8),

            child: Padding(padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.15),
                      shape: BoxShape.circle
                    ),
                    child: Icon(
                      Icons.emoji_emotions,
                      color: c,
                      size: 28,
                    ),

                  ),
                  const SizedBox(width: 12,),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _label(e.mood),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: c
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            e.note?.trim().isNotEmpty == true
                                ? e.note!.trim()
                                : 'No note',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          e.id,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          final providerContext = context; // ✅ Provider ka context store
                          showDialog(
                            context: providerContext,
                            builder: (dialogContext) => _EditNoteDialog(
                              id: e.id,
                              old: e.note ?? '',
                            ),
                          );
                        },
                           icon:  const Icon(Icons.edit, size: 20),
                        color: Colors.grey.shade600,
                      )
                    ],
                  )

                ],
              ),
            ),
          );
          },
        ),
      ),
    );
  }

  // Mood → human label (optional)
  String _label(MoodType m) => switch (m) {
    MoodType.happy => 'Happy',
    MoodType.sad => 'Sad',
    MoodType.angry => 'Angry',
    MoodType.neutral => 'Neutral',
  };

  // Mood → Color (main mapping)
  Color _moodColor(MoodType m) => switch (m) {
    MoodType.happy => const Color(0xFF22C55E),  // green
    MoodType.sad => const Color(0xFF008080),    // blue
    MoodType.angry => const Color(0xFFEF4444),  // red
    MoodType.neutral => const Color(0xFF6A1B9A),// gray
  };
}



class _EditNoteDialog extends StatefulWidget {
  final String id;
  final String old;
  const _EditNoteDialog({required this.id, required this.old});

  @override
  State<_EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<_EditNoteDialog> {
  late final TextEditingController _c = TextEditingController(text: widget.old);
  bool _isSaving = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.edit_note, color: Colors.blue),
            const SizedBox(width: 8),
            const Text(
              'Edit Note',
              style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 3,
              controller: _c,
              decoration: InputDecoration(
                hintText: 'Type your note here...',
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
      ],
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text('Cancel' , style:  TextStyle(
               color: Colors.blue
    ),),
          ),
             ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blue,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                 ),
                 icon: _isSaving
                 ? const SizedBox(
                   width: 18,
                   height: 18,
                   child: CircularProgressIndicator(
                     color: Colors.white,
                     strokeWidth: 2,
                   ),
                 )
                 : const Icon(Icons.save, color: Colors.white,),
               label: Text(_isSaving ? 'Saving...' : 'Save', style: TextStyle(
                 color: Colors.white
               ),),

                 onPressed:  _isSaving
                 ? null
                     : ()async{
                   setState(() => _isSaving = true);
                   await context
                       .read<MoodProvider?>()!
                       .editNote(widget.id, _c.text.trim());
                   if (mounted) {
                     Navigator.pop(context);
                   }

                 }



             )
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyHistory({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView( // RefreshIndicator ko scrollable chahiye
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 80),
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Center(
            child: Text(
              'No history yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 6),
          Center(
            child: Text(
              'Log today’s mood to get started',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

