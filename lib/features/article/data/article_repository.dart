import 'package:dio/dio.dart';
import 'article_model.dart';

class ArticleRepository {
  final String _apiKey = '731a3b7d3a3c4d3a89059f2c1a966043';

  // using Dio for easier API calls
  final Dio _dio = Dio();

  /// Method 1: Getting Top Headlines (For Home Screen)
  /// Fetching news based on a category like 'technology', 'sports', etc.
  Future<List<ArticleModel>> getTopHeadlines(String category) async {
    const String url = 'https://newsapi.org/v2/top-headlines';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'country': 'us',       // Fetching US news
          'category': category,  // e.g. 'technology'
          'apiKey': _apiKey,
        },
      );

      return _parseResponse(response);
    } catch (e) {
      // If error, print it to console and return empty list to prevent crash
      print("Error fetching headlines: $e");
      return [];
    }
  }

  /// Method 2: Searching Articles (For Search Screen)
  /// Fetching news based on a specific keyword query.
  Future<List<ArticleModel>> searchArticles(String query) async {
    const String url = 'https://newsapi.org/v2/everything';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          'q': query,            // The user's search text
          'apiKey': _apiKey,
          'sortBy': 'publishedAt', // Newest first
          'language': 'en',      // English results only
        },
      );

      return _parseResponse(response);
    } catch (e) {
      print("Error searching articles: $e");
      throw Exception("Failed to search news");
    }
  }

  /// Helper method to parse the raw JSON into a List of ArticleModels
  List<ArticleModel> _parseResponse(Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      if (data['articles'] != null) {
        final List<dynamic> articlesJson = data['articles'];
        // Map each JSON object to our ArticleModel
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }
    }
    return [];
  }
}