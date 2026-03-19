import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/challenge.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Challenge> completedChallenges = [];

  @override
  void initState() {
    super.initState();
    loadCompleted();
  }

  Future<void> loadCompleted() async {
    final all = await DatabaseHelper.instance.getAllChallenges();
    setState(() {
      completedChallenges =
          all.map((c) => Challenge.fromMap(c)).where((c) => c.progress >= c.goal).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (completedChallenges.isEmpty) {
      return const Center(child: Text("No completed challenges yet!"));
    }
    return ListView.builder(
      itemCount: completedChallenges.length,
      itemBuilder: (context, index) {
        final c = completedChallenges[index];
        return ListTile(
          title: Text(c.title),
          subtitle: Text("Completed on ${c.createdAt.split('T')[0]}"),
        );
      },
    );
  }
}