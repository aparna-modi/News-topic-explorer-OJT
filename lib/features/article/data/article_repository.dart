// Importing the Dio package for making HTTP requests.
import 'package:dio/dio.dart';
// Importing the article model to structure the data.
import 'article_model.dart';

// A class responsible for fetching article data from the NewsAPI.
class ArticleRepository {
  // Your private API key for accessing the NewsAPI.
  final String _apiKey = '731a3b7d3a3c4d3a89059f2c1a966043';

  // An instance of Dio for making network requests.
  final Dio _dio = Dio();

  // Fetches the top headlines for a specific category.
  Future<List<ArticleModel>> getTopHeadlines(String category) async {
    // The endpoint for top headlines.
    const String url = 'https://newsapi.org/v2/top-headlines';

    try {
      // Making a GET request to the API.
      final response = await _dio.get(
        url,
        queryParameters: {
          'country': 'us', // Fetching news from the US.
          'category': category, // The category to fetch news for.
          'sortBy': 'publishedAt', // Sorting the news by publication date.
          'apiKey': _apiKey, // Your API key.
        },
      );

      // Parsing the response and returning a list of articles.
      return _parseResponse(response);
    } catch (e) {
      // Printing an error message if the request fails.
      print("Error fetching headlines: $e");
      // Returning an empty list to avoid crashing the app.
      return [];
    }
  }

  // Searches for articles based on a query.
  Future<List<ArticleModel>> searchArticles(String query) async {
    // The endpoint for searching all articles.
    const String url = 'https://newsapi.org/v2/everything';

    try {
      // Making a GET request to the API.
      final response = await _dio.get(
        url,
        queryParameters: {
          'q': query, // The search query.
          'apiKey': _apiKey, // Your API key.
          'sortBy': 'publishedAt', // Sorting the news by publication date.
          'language': 'en', // Fetching news in English only.
        },
      );

      // Parsing the response and returning a list of articles.
      return _parseResponse(response);
    } catch (e) {
      // Printing an error message if the request fails.
      print("Error searching articles: $e");
      // Throwing an exception to be handled by the caller.
      throw Exception("Failed to search news");
    }
  }

  // A helper method to parse the JSON response into a list of articles.
  List<ArticleModel> _parseResponse(Response response) {
    // Checking if the request was successful.
    if (response.statusCode == 200) {
      // Getting the response data.
      final Map<String, dynamic> data = response.data;

      // Checking if the response contains any articles.
      if (data['articles'] != null) {
        // Getting the list of articles from the response.
        final List<dynamic> articlesJson = data['articles'];
        // Mapping the JSON objects to ArticleModel instances.
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }
    }
    // Returning an empty list if the request was not successful.
    return [];
  }
}
