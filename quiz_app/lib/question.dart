/// Data model for quiz questions
/// 
/// This class represents a single quiz question with its options and correct answer.
/// It handles JSON serialization/deserialization for API responses.

class Question {
  // IMPLEMENTATION GUIDE:
  // 1. Define properties for storing question data
  final String id;              // Unique identifier for the question
  final String question;        // The question text
  final List<String> options;   // List of answer options (typically 4 options)
  final String correctAnswer;   // The correct answer from the options list
  final String category;        // Optional: question category/topic
  final String difficulty;      // Optional: difficulty level (easy, medium, hard)

  // 2. Constructor - initialize all properties
  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.category = '',
    this.difficulty = 'medium',
  });

  // 3. fromJson factory constructor - converts API JSON response to Question object
  /// Parses JSON response from API and creates a Question instance
  /// 
  /// Example API response:
  /// {
  ///   "id": "q1",
  ///   "question": "What is 2+2?",
  ///   "options": ["3", "4", "5", "6"],
  ///   "correctAnswer": "4",
  ///   "category": "Math",
  ///   "difficulty": "easy"
  /// }
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
    );
  }

  // 4. toJson method - converts Question object to JSON for sending to API
  /// Converts this Question instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'category': category,
      'difficulty': difficulty,
    };
  }
}
