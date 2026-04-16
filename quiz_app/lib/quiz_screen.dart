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

      setState(() {
        questions = loadedQuestions;
        if (questions.isEmpty) {
          errorMessage = 'No questions available';
          screenState = 'error';
        } else {
          screenState = 'quiz';
          // Start timer
          _startTimer();
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading questions: $e';
        screenState = 'error';
      });
    }
  }

  /// Start timer to track quiz duration
  /// 
  /// You may want to use a Timer or Stream for this
  /// Consider using: import 'dart:async';
  void _startTimer() {
    // TODO: Implement timer using Timer or Stream
    // Update secondsElapsed every second
    // Example: Timer.periodic(Duration(seconds: 1), (timer) { ... })
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
    // TODO: Implement answer selection logic
    // 1. Store answer: userAnswers[questions[currentQuestionIndex].id] = selectedAnswer
    // 2. Check if correct: if (selectedAnswer == questions[currentQuestionIndex].correctAnswer)
    // 3. If correct, increment score
    // 4. Move to next question or show results
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
        userId: 'user123', // TODO: Get actual user ID
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Score: $score / ${questions.length}',
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            'Percentage: $percentage%',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Time: ${minutes}m ${seconds}s',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _restartQuiz,
                child: const Text('Try Again'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Exit'),
              ),
            ],
          ),
        ],
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: switch (screenState) {
            'loading' => _buildLoadingScreen(),
            'quiz' => _buildQuizScreen(),
            'results' => _buildResultsScreen(),
            'error' => _buildErrorScreen(),
            _ => _buildErrorScreen(),
          },
        ),
      ),
    );
  }
}
