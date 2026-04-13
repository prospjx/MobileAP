import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';

class TaskListScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const TaskListScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Task> _tasks = [];
  StreamSubscription<QuerySnapshot>? _taskSubscription;
  bool _isLoading = true;
  String? _streamError;

  @override
  void initState() {
    super.initState();
    _subscribeToTasks();
  }

  void _subscribeToTasks() {
    _taskSubscription = FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('createdAt')
        .snapshots()
        .listen(
      _applySnapshot,
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _streamError = error.toString();
          _isLoading = false;
        });
      },
    );
  }

  void _applySnapshot(QuerySnapshot snapshot) {
    final nextTasks = snapshot.docs
        .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    if (!mounted) return;

    final listState = _listKey.currentState;
    if (listState == null) {
      setState(() {
        _tasks
          ..clear()
          ..addAll(nextTasks);
        _streamError = null;
        _isLoading = false;
      });
      return;
    }

    final nextIds = nextTasks.map((task) => task.id).toSet();
    for (int i = _tasks.length - 1; i >= 0; i--) {
      if (!nextIds.contains(_tasks[i].id)) {
        final removedTask = _tasks.removeAt(i);
        listState.removeItem(
          i,
          (context, animation) => _buildAnimatedTaskTile(removedTask, animation),
          duration: const Duration(milliseconds: 250),
        );
      }
    }

    bool reordered = false;
    for (int newIndex = 0; newIndex < nextTasks.length; newIndex++) {
      final incoming = nextTasks[newIndex];
      final currentIndex = _tasks.indexWhere((task) => task.id == incoming.id);

      if (currentIndex == -1) {
        _tasks.insert(newIndex, incoming);
        listState.insertItem(newIndex, duration: const Duration(milliseconds: 250));
      } else {
        _tasks[currentIndex] = incoming;
        if (currentIndex != newIndex) {
          final moved = _tasks.removeAt(currentIndex);
          _tasks.insert(newIndex, moved);
          reordered = true;
        }
      }
    }

    setState(() {
      _streamError = null;
      _isLoading = false;
    });

    if (reordered) {
      setState(() {});
    }
  }

  // Firestore version (Phase D)
  Future<void> _addTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    await addTaskToFirestore(title);
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
    _taskSubscription?.cancel();
    _taskController.dispose(); // IMPORTANT: always dispose controllers
    super.dispose();
  }

  Widget _buildAnimatedTaskTile(Task task, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: animation,
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeIcon = switch (widget.themeMode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };

    final themeLabel = switch (widget.themeMode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            tooltip: 'Theme: $themeLabel (tap to switch)',
            icon: Icon(themeIcon),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Input row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  onSubmitted: (_) => _addTask(),
                  decoration: const InputDecoration(hintText: 'New task name...'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addTask, child: const Text('Add')),
            ]),
          ),
          // ── Task list ──────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _streamError != null
                    ? Center(child: Text('Error: $_streamError'))
                    : _tasks.isEmpty
                        ? const Center(child: Text('No tasks yet. Add one above!'))
                        : AnimatedList(
                            key: _listKey,
                            initialItemCount: _tasks.length,
                            itemBuilder: (context, index, animation) {
                              return _buildAnimatedTaskTile(_tasks[index], animation);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}