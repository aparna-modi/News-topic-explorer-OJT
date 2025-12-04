// Importing the Riverpod package for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the article model to structure the data.
import '../../data/article_model.dart';
// Importing the article repository to fetch data.
import '../../data/article_repository.dart';

// A FutureProvider that fetches articles from all categories, shuffles them, and provides them as a single list.
final allArticlesProvider = FutureProvider.autoDispose<List<ArticleModel>>((ref) async {
  // Accessing the article repository through a provider.
  final articleRepository = ref.watch(Provider<ArticleRepository>((ref) => ArticleRepository()));
  // A list of all the news categories to be fetched.
  final categories = [
    'technology',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
  ];

  // An empty list to hold all the fetched articles.
  final allArticles = <ArticleModel>[];
  // Looping through each category to fetch the top headlines.
  for (final category in categories) {
    // Fetching the articles for the current category.
    final articles = await articleRepository.getTopHeadlines(category);
    // Adding the fetched articles to the main list.
    allArticles.addAll(articles);
  }

  // Shuffling the list to show a mix of articles from different categories.
  allArticles.shuffle();
  // Returning the complete list of articles.
  return allArticles;
});
