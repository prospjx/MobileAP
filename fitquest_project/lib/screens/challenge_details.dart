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

  Future<void> updateProgress(int dayIndex) async {
    final nextDayIndex = challenge.progress;
    final lastCheckedDayIndex = challenge.progress - 1;

    if (dayIndex != nextDayIndex && dayIndex != lastCheckedDayIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Track days in order. Check the next day or undo the latest day.'),
        ),
      );
      return;
    }

    final shouldUndo = dayIndex == lastCheckedDayIndex;
    final nextProgress = shouldUndo ? challenge.progress - 1 : challenge.progress + 1;

    setState(() {
      challenge.progress = nextProgress;
    });

    await DatabaseHelper.instance.updateChallenge(challenge.id!, challenge.toMap());
  }

  Future<void> resetProgress() async {
    setState(() {
      challenge.progress = 0;
    });

    await DatabaseHelper.instance.updateChallenge(challenge.id!, challenge.toMap());
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
    final isCompleted = challenge.progress >= challenge.goal;

    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description: ${challenge.description}"),
              const SizedBox(height: 10),
              Text("Progress: ${challenge.progress}/${challenge.goal}"),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: challenge.goal == 0 ? 0 : challenge.progress / challenge.goal,
              ),
              const SizedBox(height: 20),
              Text(
                "Daily Goal Tracker",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(challenge.goal, (index) {
                  final done = index < challenge.progress;
                  final dayLabel = "Day ${index + 1}";

                  return GestureDetector(
                    onTap: () => updateProgress(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: done
                              ? Colors.green
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            done ? Icons.check : Icons.circle_outlined,
                            size: 18,
                            color: done
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(dayLabel),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                isCompleted
                  ? "Completed. All goal days are checked."
                  : "Check days in order, one circle at a time.",
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: resetProgress,
                    child: const Text("Reset Progress"),
                  ),
                  ElevatedButton(
                    onPressed: editChallenge,
                    child: const Text("Edit"),
                  ),
                  ElevatedButton(
                    onPressed: deleteChallenge,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}