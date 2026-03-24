import 'package:flutter/material.dart';
import '../utils/preferences.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool>? onThemeChanged;

  const SettingsScreen({
    super.key,
    this.isDark = false,
    this.onThemeChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    int streak = await Preferences.getStreak();
    setState(() {
      _streak = streak;
    });
  }

  void toggleTheme(bool value) {
    widget.onThemeChanged?.call(value);
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
    final isDarkEnabled = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkEnabled,
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