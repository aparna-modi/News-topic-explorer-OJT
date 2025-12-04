import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/article_model.dart';
import '../../data/article_repository.dart';

// Provider for ArticleRepository
final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepository();
});

// FutureProvider for top headlines by category
final topHeadlinesProvider = FutureProvider.autoDispose.family<List<ArticleModel>, String>((ref, category) async {
  final articleRepository = ref.watch(articleRepositoryProvider);
  return articleRepository.getTopHeadlines(category);
});
