import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../database/database_helper.dart';
import 'create_challenge.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailsScreen({super.key, required this.challenge});

  @override
  _ChallengeDetailsScreenState createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  late Challenge challenge;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  void completeChallenge() async {
    setState(() {
      challenge.progress = challenge.goal;
    });
    await DatabaseHelper.instance
        .updateChallenge(challenge.id!, challenge.toMap());
  }

  void deleteChallenge() async {
    await DatabaseHelper.instance.deleteChallenge(challenge.id!);
    Navigator.pop(context);
  }

  void editChallenge() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateChallengeScreen(challenge: challenge)),
    );
    final updated = await DatabaseHelper.instance.getChallenge(challenge.id!);
    if (updated != null) {
      setState(() {
        challenge = Challenge.fromMap(updated);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${challenge.description}"),
            const SizedBox(height: 10),
            Text("Progress: ${challenge.progress}/${challenge.goal}"),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: completeChallenge,
                  child: const Text("Mark Complete"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: editChallenge,
                  child: const Text("Edit"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: deleteChallenge,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}