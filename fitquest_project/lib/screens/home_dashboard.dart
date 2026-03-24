import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/challenge.dart';
import '../widgets/challenge_card.dart';
import 'create_challenge.dart';
import 'challenge_details.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeDashboard extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool>? onThemeChanged;

  const HomeDashboard({
    super.key,
    this.isDark = false,
    this.onThemeChanged,
  });

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  List<Challenge> challenges = [];

  @override
  void initState() {
    super.initState();
    loadChallenges();
  }

  Future<void> loadChallenges() async {
    final all = await DatabaseHelper.instance.getAllChallenges();
    setState(() {
      challenges = all.map((c) => Challenge.fromMap(c)).toList();
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getCurrentScreen() {
    if (_selectedIndex == 0) return buildHome();
    if (_selectedIndex == 1) return const ProgressScreen();
    return SettingsScreen(
      isDark: widget.isDark,
      onThemeChanged: widget.onThemeChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget buildHome() {
    return Scaffold(
      appBar: AppBar(title: const Text("FitQuest Dashboard")),
      body: challenges.isEmpty
          ? const Center(
              child: Text(
                "No challenges yet. Tap + to create one!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return ChallengeCard(
                  challenge: challenges[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChallengeDetailsScreen(challenge: challenges[index]),
                      ),
                    ).then((_) => loadChallenges());
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateChallengeScreen()),
          ).then((_) => loadChallenges());
        },
      ),
    );
  }
}