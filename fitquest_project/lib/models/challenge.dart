class Challenge {
  int? id;
  String title;
  String description;
  int goal;
  int progress;
  String createdAt;

  Challenge({
    this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.progress,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'goal': goal,
      'progress': progress,
      'created_at': createdAt,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      goal: map['goal'],
      progress: map['progress'],
      createdAt: map['created_at'],
    );
  }
}