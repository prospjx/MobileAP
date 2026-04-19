import 'dart:async';

import 'package:flutter/material.dart';
import 'question.dart';
import 'api_service.dart';

/// Main quiz screen widget
/// 
/// This screen displays quiz questions one at a time, handles user answers,
/// tracks time, and displays the final score/results.

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // IMPLEMENTATION GUIDE:
  
  // 1. State variables - data that changes during the quiz
  
  /// List of all quiz questions fetched from API
  List<Question> questions = [];
  
  /// Current question index (which question we're on)
  int currentQuestionIndex = 0;
  
  /// Score counter - increment when user answers correctly
  int score = 0;
  
  /// Timer to track quiz duration
  int secondsElapsed = 0;
  
  /// Map to track user's answers: questionId -> selectedAnswer
  Map<String, String> userAnswers = {};
  
  /// Current state of the screen: loading, quiz, results
  String screenState = 'loading'; // loading, quiz, results
  
  /// Error message to display (if any)
  String? errorMessage;
  
  /// API service instance for fetching questions and submitting results
  late ApiService apiService;

  /// Periodic timer for tracking elapsed time
  Timer? _quizTimer;

  // 2. Lifecycle methods
  
  /// Initialize state - called once when widget is created
  @override
  void initState() {
    super.initState();
    // Initialize API service
    apiService = ApiService();
    // Load questions from API
    _loadQuestions();
  }

  /// Cleanup - called when widget is destroyed
  @override
  void dispose() {
    // Clean up resources
    _quizTimer?.cancel();
    apiService.dispose();
    super.dispose();
  }

  // 3. Core quiz methods
  
  /// Load questions from the API
  /// 
  /// This method:
  /// - Calls ApiService.fetchQuestions()
  /// - Updates the questions list
  /// - Handles loading and error states
  /// - Changes screen state to 'quiz' when ready
  Future<void> _loadQuestions() async {
    try {
      setState(() {
        screenState = 'loading';
        errorMessage = null;
      });

      // Fetch questions from API
      final loadedQuestions = await apiService.fetchQuestions(
        category: 'general', // Optional: filter by category
        difficulty: 'medium', // Optional: filter by difficulty
      );

      final resolvedQuestions =
          loadedQuestions.isEmpty ? _getFallbackQuestions() : loadedQuestions;

      setState(() {
        questions = resolvedQuestions;
        screenState = 'quiz';
      });
      _startTimer();
    } catch (e) {
      setState(() {
        errorMessage = 'Using offline questions (API error: $e)';
        questions = _getFallbackQuestions();
        screenState = 'quiz';
      });
      _startTimer();
    }
  }

  List<Question> _getFallbackQuestions() {
    return [
      Question(
        id: 'local_1',
        question: 'What is the capital city of France?',
        options: const ['Paris', 'Rome', 'Madrid', 'Berlin'],
        correctAnswer: 'Paris',
        category: 'General Knowledge',
        difficulty: 'easy',
      ),
      Question(
        id: 'local_2',
        question: 'Which planet is known as the Red Planet?',
        options: const ['Earth', 'Mars', 'Jupiter', 'Venus'],
        correctAnswer: 'Mars',
        category: 'Science',
        difficulty: 'easy',
      ),
      Question(
        id: 'local_3',
        question: 'What is 7 x 8?',
        options: const ['54', '56', '58', '64'],
        correctAnswer: '56',
        category: 'Math',
        difficulty: 'easy',
      ),
      Question(
        id: 'local_4',
        question: 'In Flutter, which widget lays out children vertically?',
        options: const ['Row', 'Stack', 'Column', 'Wrap'],
        correctAnswer: 'Column',
        category: 'Programming',
        difficulty: 'medium',
      ),
      Question(
        id: 'local_5',
        question: 'Which ocean is the largest on Earth?',
        options: const ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
        correctAnswer: 'Pacific',
        category: 'Geography',
        difficulty: 'easy',
      ),
    ];
  }

  /// Start timer to track quiz duration
  /// 
  /// You may want to use a Timer or Stream for this
  /// Consider using: import 'dart:async';
  void _startTimer() {
    _quizTimer?.cancel();
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || screenState != 'quiz') {
        timer.cancel();
        return;
      }

      setState(() {
        secondsElapsed++;
      });
    });
  }

  /// Record user's answer to current question
  /// 
  /// Parameters:
  ///   - selectedAnswer: The option the user clicked
  /// 
  /// This method:
  /// - Stores the answer in userAnswers map
  /// - Checks if answer is correct and updates score
  /// - Moves to next question or shows results
  void _selectAnswer(String selectedAnswer) {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return;
    }

    final currentQuestion = questions[currentQuestionIndex];

    setState(() {
      userAnswers[currentQuestion.id] = selectedAnswer;
      if (selectedAnswer == currentQuestion.correctAnswer) {
        score++;
      }
    });

    _nextQuestion();
  }

  /// Move to the next question
  /// 
  /// This method:
  /// - Increments currentQuestionIndex
  /// - Updates UI with new question
  /// - Shows results if this was the last question
  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex >= questions.length) {
        // Quiz is complete - show results
        screenState = 'results';
        _quizTimer?.cancel();
      }
    });
  }

  /// Submit quiz results to API
  /// 
  /// This method:
  /// - Calls ApiService.submitResults()
  /// - Passes user's answers, score, and time taken
  /// - Handles success/error responses
  Future<void> _submitResults() async {
    try {
      await apiService.submitResults(
        userId: 'user123', 
        answers: userAnswers,
        score: score,
        timeTaken: secondsElapsed,
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Results submitted successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting results: $e')),
      );
    }
  }

  /// Restart the quiz
  /// 
  /// This method:
  /// - Resets all state variables
  /// - Reloads questions from API
  void _restartQuiz() {
    _quizTimer?.cancel();
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      secondsElapsed = 0;
      userAnswers = {};
    });
    _loadQuestions();
  }

  // 4. UI builder methods
  
  /// Build the loading screen
  /// 
  /// This method displays:
  /// - A loading spinner
  /// - Optional loading message
  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading questions...'),
        ],
      ),
    );
  }

  /// Build the error screen
  /// 
  /// This method displays:
  /// - Error message
  /// - Retry button
  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            errorMessage ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadQuestions,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build the main quiz screen
  /// 
  /// This method displays:
  /// - Progress bar (current question / total questions)
  /// - Question text
  /// - Answer options as buttons
  /// - Score and timer (optional)
  Widget _buildQuizScreen() {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return _buildErrorScreen();
    }

    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;
    final minutes = secondsElapsed ~/ 60;
    final seconds = secondsElapsed % 60;

    return Column(
      children: [
        // Header with progress and score
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Score: $score',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Time: ${minutes}m ${seconds}s',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ),
        // Progress bar
        LinearProgressIndicator(value: progress),
        // Question and options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question text
                Text(
                  question.question,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                // Answer options
                ...question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(option),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(option),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build the results screen
  /// 
  /// This method displays:
  /// - Final score
  /// - Percentage correct
  /// - Time taken
  /// - Results breakdown
  /// - Buttons to restart or exit quiz
  Widget _buildResultsScreen() {
    final percentage = ((score / questions.length) * 100).toStringAsFixed(1);
    final minutes = secondsElapsed ~/ 60;
    final seconds = secondsElapsed % 60;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 380),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Quiz Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Score: $score / ${questions.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'Percentage: $percentage%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Time: ${minutes}m ${seconds}s',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _restartQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Quiz'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Main build method - combines all screens
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Application'),
        elevation: 0,
        actions: [
          if (screenState == 'results')
            IconButton(
              onPressed: _restartQuiz,
              tooltip: 'Restart Quiz',
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: switch (screenState) {
        'loading' => _buildLoadingScreen(),
        'quiz' => _buildQuizScreen(),
        'results' => _buildResultsScreen(),
        'error' => _buildErrorScreen(),
        _ => _buildErrorScreen(),
      },
    );
  }
}
