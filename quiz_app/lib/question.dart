/// Data model for quiz questions
///
/// This class represents a single quiz question with its options and correct answer.
/// It handles JSON serialization/deserialization for API responses.

class Question {
  // IMPLEMENTATION GUIDE:
  // 1. Define properties for storing question data
  final String id; // Unique identifier for the question
  final String question; // The question text
  final List<String> options; // List of answer options (typically 4 options)
  final String correctAnswer; // The correct answer from the options list
  final String category; // Optional: question category/topic
  final String difficulty; // Optional: difficulty level (easy, medium, hard)

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
    final String questionText = _decodeHtmlEntities(
      (json['question'] ?? json['text'] ?? '').toString(),
    );
    final String answer = _decodeHtmlEntities(
      (json['correctAnswer'] ?? json['correct_answer'] ?? '').toString(),
    );

    final optionsFromApi = json['options'];
    final wrongAnswersFromApi = json['incorrect_answers'];

    List<String> parsedOptions;
    if (optionsFromApi is List) {
      parsedOptions = optionsFromApi
          .map((e) => _decodeHtmlEntities(e.toString()))
          .toList();
    } else {
      parsedOptions = [
        if (answer.isNotEmpty) answer,
        if (wrongAnswersFromApi is List)
          ...wrongAnswersFromApi.map((e) => _decodeHtmlEntities(e.toString())),
      ];
      parsedOptions = parsedOptions.toSet().toList()..shuffle();
    }

    return Question(
      id: (json['id'] ?? questionText.hashCode.toString()).toString(),
      question: questionText,
      options: parsedOptions,
      correctAnswer: answer,
      category: (json['category'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? 'medium').toString(),
    );
  }

  static String _decodeHtmlEntities(String text) {
    const namedEntities = {
      '&quot;': '"',
      '&#34;': '"',
      '&apos;': "'",
      '&#39;': "'",
      '&#039;': "'",
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&nbsp;': ' ',
      '&ldquo;': '"',
      '&rdquo;': '"',
      '&lsquo;': "'",
      '&rsquo;': "'",
      '&hellip;': '...',
      '&ndash;': '-',
      '&mdash;': '--',
    };

    var decoded = text;
    namedEntities.forEach((entity, value) {
      decoded = decoded.replaceAll(entity, value);
    });

    decoded = decoded.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final codePoint = int.tryParse(match.group(1)!);
      if (codePoint == null) {
        return match.group(0)!;
      }
      return String.fromCharCode(codePoint);
    });

    decoded = decoded.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (match) {
      final codePoint = int.tryParse(match.group(1)!, radix: 16);
      if (codePoint == null) {
        return match.group(0)!;
      }
      return String.fromCharCode(codePoint);
    });

    return decoded;
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
