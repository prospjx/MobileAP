import 'package:flutter/material.dart';
import '../utils/preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    bool theme = await Preferences.getTheme();
    int streak = await Preferences.getStreak();
    setState(() {
      _isDark = theme;
      _streak = streak;
    });
  }

  void toggleTheme(bool value) {
    setState(() {
      _isDark = value;
    });
    Preferences.saveTheme(value);
  }

  void resetStreak() {
    setState(() {
      _streak = 0;
    });
    Preferences.saveStreak(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: _isDark,
            onChanged: toggleTheme,
          ),
          ListTile(
            title: Text("Current Streak: $_streak days"),
            trailing: ElevatedButton(
              onPressed: resetStreak,
              child: const Text("Reset"),
            ),
          ),
        ],
      ),
    );
  }
}