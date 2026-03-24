import 'package:flutter/material.dart';
import 'home_dashboard.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool>? onThemeChanged;

  const SplashScreen({
    super.key,
    this.isDark = false,
    this.onThemeChanged,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeDashboard(
            isDark: widget.isDark,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}