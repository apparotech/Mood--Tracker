import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/providers/auth_provider.dart';
import 'package:mood_tracker/screens/providers/mood_provider.dart';
import 'package:provider/provider.dart';

import 'auth/login_screen.dart';

class MoodInsightsScreen extends StatelessWidget {
  const MoodInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MoodProvider?>();
    if(mp == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),


      );

    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Insights',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>  AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),

                        TextButton(
                          onPressed: () {
                            context.read<AuthProviders>().signOut();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                    (route) => false, // purana stack clear
                              );
                            }
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    )
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          )
        ],


      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
             children: [
               _Card(title: 'Most Frequent', value: mp.mostFrequent?.name ?? '_'),
               _Card(title: 'Happy % , ', value: '${mp.happyPercent.toStringAsFixed(0)}%'),
               _Card(title: 'Longest Streak', value: '${mp.longestStreak} days')
             ],
        ),
      ),

    );
  }
}

class _Card extends StatelessWidget {
  final String title, value;
  const _Card({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // halkasa shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // rounded edges
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade900,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

