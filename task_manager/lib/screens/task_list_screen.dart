import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();

  // Firestore version (Phase D)
  void _addTask() {
    addTaskToFirestore(_taskController.text);
    _taskController.clear();
  }

  Future<void> addTaskToFirestore(String title) async {
    if (title.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('tasks').add({
      'title': title.trim(),
      'isCompleted': false,
      'subtasks': [],
      'createdAt': DateTime.now().toIso8601String(),
    });
    // No setState() needed here - stream/listener updates UI.
  }

  // Toggle isCompleted in Firestore
  Future<void> toggleTask(Task task) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': !task.isCompleted});
  }

  // Permanently delete a task
  Future<void> deleteTask(String taskId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  @override
  void dispose() {
    _taskController.dispose(); // IMPORTANT: always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          // ── Input row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(controller: _taskController,
                decoration: const InputDecoration(hintText: 'New task name...'),
              )),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addTask, child: const Text('Add')),
            ]),
          ),
          // ── Task list ──────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No tasks yet. Add one above!'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final task = Task.fromMap(
                      docs[index].id,
                      docs[index].data() as Map<String, dynamic>,
                    );

                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => toggleTask(task),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => deleteTask(task.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}