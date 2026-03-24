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

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _goalFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.challenge != null) {
      _titleController.text = widget.challenge!.title;
      _descController.text = widget.challenge!.description;
      _goalController.text = widget.challenge!.goal.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _goalController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    _goalFocus.dispose();
    super.dispose();
  }

  void saveChallenge() async {
    if (!_formKey.currentState!.validate()) return;

    final goal = int.parse(_goalController.text);
    final existingProgress = widget.challenge?.progress ?? 0;

    Challenge newChallenge = Challenge(
      title: _titleController.text,
      description: _descController.text,
      goal: goal,
      progress: existingProgress > goal ? goal : existingProgress,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _descFocus.requestFocus(),
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) =>
                      value!.isEmpty ? "Title cannot be empty" : null,
                ),
                TextFormField(
                  controller: _descController,
                  focusNode: _descFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _goalFocus.requestFocus(),
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextFormField(
                  controller: _goalController,
                  focusNode: _goalFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => saveChallenge(),
                  decoration: const InputDecoration(labelText: "Goal"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return "Goal must be a number greater than 0";
                    }
                    return null;
                  },
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
      ),
    );
  }
}