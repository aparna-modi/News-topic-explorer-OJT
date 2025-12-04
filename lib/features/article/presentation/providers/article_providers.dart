// Importing the Riverpod package for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the article model to structure the data.
import '../../data/article_model.dart';
// Importing the article repository to fetch data.
import '../../data/article_repository.dart';

// A provider that creates and provides an instance of ArticleRepository.
final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  // Returning a new instance of the repository.
  return ArticleRepository();
});

// A FutureProvider that fetches top headlines for a specific category.
// It takes a category as a parameter and automatically handles caching and disposal.
final topHeadlinesProvider = FutureProvider.autoDispose.family<List<ArticleModel>, String>((ref, category) async {
  // Watching the articleRepositoryProvider to get an instance of the repository.
  final articleRepository = ref.watch(articleRepositoryProvider);
  // Fetching the top headlines for the given category and returning them.
  return articleRepository.getTopHeadlines(category);
});
