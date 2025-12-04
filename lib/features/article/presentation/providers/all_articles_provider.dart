import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/article_model.dart';
import '../../data/article_repository.dart';

final allArticlesProvider = FutureProvider.autoDispose<List<ArticleModel>>((ref) async {
  final articleRepository = ref.watch(Provider<ArticleRepository>((ref) => ArticleRepository()));
  final categories = [
    'technology',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
  ];

  final allArticles = <ArticleModel>[];
  for (final category in categories) {
    final articles = await articleRepository.getTopHeadlines(category);
    allArticles.addAll(articles);
  }

  allArticles.shuffle();
  return allArticles;
});
