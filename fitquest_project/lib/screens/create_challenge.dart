import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../database/database_helper.dart';

class CreateChallengeScreen extends StatefulWidget {
  final Challenge? challenge; // If editing

  const CreateChallengeScreen({super.key, this.challenge});

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState(); 
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.challenge != null) {
      _titleController.text = widget.challenge!.title;
      _descController.text = widget.challenge!.description;
      _goalController.text = widget.challenge!.goal.toString();
    }
  }

  void saveChallenge() async {
    if (!_formKey.currentState!.validate()) return;

    Challenge newChallenge = Challenge(
      title: _titleController.text,
      description: _descController.text,
      goal: int.parse(_goalController.text),
      progress: widget.challenge?.progress ?? 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    if (widget.challenge == null) {
      await DatabaseHelper.instance.createChallenge(newChallenge.toMap());
    } else {
      await DatabaseHelper.instance
          .updateChallenge(widget.challenge!.id!, newChallenge.toMap());
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge == null ? "Add Challenge" : "Edit Challenge"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value!.isEmpty ? "Title cannot be empty" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: "Goal"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || int.tryParse(value) == null
                        ? "Enter a valid number"
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveChallenge,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}