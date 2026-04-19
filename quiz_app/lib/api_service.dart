import 'package:http/http.dart' as http;
import 'dart:convert';
import 'question.dart';

/// Service class for handling API calls
///
/// This class manages all communication with the quiz API backend.
/// It handles fetching questions, submitting answers, and error handling.

class ApiService {
  // IMPLEMENTATION GUIDE:

  // 1. Define API endpoint constants
  /// Base URL for the quiz API - adjust this to your actual backend URL
  static const String baseUrl = 'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple';

  /// Endpoint to fetch quiz questions
  static const String questionsEndpoint = '/api.php';

  /// Endpoint to submit quiz results
  static const String resultsEndpoint = '/results';

  // 2. HTTP client instance for making requests
  final http.Client _httpClient = http.Client();

  // 3. Method to fetch questions from the API
  /// Fetches a list of quiz questions from the server
  ///
  /// Parameters:
  ///   - category: Optional filter by category
  ///   - difficulty: Optional filter by difficulty level
  ///
  /// Returns: List of Question objects
  ///
  /// Implementation steps:
  /// - Build the URL with query parameters if provided
  /// - Make a GET request to the server
  /// - Check the response status code (200 = success)
  /// - Parse the JSON response into Question objects
  /// - Handle errors and throw meaningful exceptions
  Future<List<Question>> fetchQuestions({
    String? category,
    String? difficulty,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {
        'amount': '10',
        'type': 'multiple',
      };
      if (difficulty != null && difficulty.isNotEmpty) {
        queryParams['difficulty'] = difficulty;
      }
      // OpenTDB expects a numeric category ID (e.g., 9 for General Knowledge).
      if (category != null && RegExp(r'^\d+$').hasMatch(category)) {
        queryParams['category'] = category;
      }

      // Create URL with query parameters
      final Uri url = Uri.parse(
        baseUrl + questionsEndpoint,
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      // Make GET request with headers
      final response = await _httpClient
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30), // 30 second timeout
            onTimeout: () =>
                throw Exception('Request timeout - server not responding'),
          );

      // Handle response
      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is List<dynamic>) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(Question.fromJson)
              .toList();
        }

        if (decoded is Map<String, dynamic>) {
          final responseCode = decoded['response_code'];
          if (responseCode is int && responseCode != 0) {
            throw Exception(
              'Question API returned response_code=$responseCode',
            );
          }

          final results = decoded['results'];
          if (results is List<dynamic>) {
            return results
                .whereType<Map<String, dynamic>>()
                .map(Question.fromJson)
                .toList();
          }
        }

        throw Exception('Unexpected questions response format');
      } else if (response.statusCode == 404) {
        throw Exception('Questions not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error - please try again later');
      } else {
        throw Exception('Failed to fetch questions: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw the exception or handle it gracefully
      throw Exception('Error fetching questions: $e');
    }
  }

  // 4. Method to submit quiz results
  /// Submits the user's quiz results to the server for scoring
  ///
  /// Parameters:
  ///   - userId: User identifier
  ///   - answers: Map of question IDs to selected answers
  ///   - score: Score achieved by the user
  ///   - timeTaken: Time taken to complete the quiz (in seconds)
  ///
  /// Returns: Response from server (success message or null on failure)
  ///
  /// Implementation steps:
  /// - Create a request body with user responses
  /// - Make a POST request to the results endpoint
  /// - Handle the response status
  /// - Return success message or throw error
  Future<Map<String, dynamic>> submitResults({
    required String userId,
    required Map<String, String> answers,
    required int score,
    required int timeTaken,
  }) async {
    try {
      // Prepare request body
      final body = jsonEncode({
        'userId': userId,
        'answers': answers,
        'score': score,
        'timeTaken': timeTaken,
        'submittedAt': DateTime.now().toIso8601String(),
      });

      // Make POST request
      final response = await _httpClient
          .post(
            Uri.parse(baseUrl + resultsEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw Exception('Request timeout - server not responding'),
          );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting results: $e');
    }
  }

  // 5. Optional: Add method to validate user credentials
  /// Authenticates user with the quiz service
  ///
  /// This is optional - add if your app requires user authentication
  Future<String?> authenticateUser({
    required String username,
    required String password,
  }) async {
    // TODO: Implement user authentication
    // Make POST request with credentials
    // Return auth token on success
    return null;
  }

  // 6. Cleanup method to close HTTP client
  /// Dispose of HTTP client resources
  /// Call this when the app is shutting down or service is no longer needed
  void dispose() {
    _httpClient.close();
  }
}
