import 'package:flutter/material.dart';
import 'mood_log_screen.dart';
import 'mood_history_screen.dart';
import 'mood_insights_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _i = 0;
  final _pages = const [MoodLogScreen(), MoodHistoryScreen(), MoodInsightsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_i],
      bottomNavigationBar: NavigationBar(


        selectedIndex: _i,
        onDestinationSelected: (v) => setState(() => _i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.add_reaction_outlined), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}
