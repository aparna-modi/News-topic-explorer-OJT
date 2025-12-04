import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/article_model.dart';

class BookmarkedArticlesNotifier extends StateNotifier<List<ArticleModel>> {
  BookmarkedArticlesNotifier() : super([]);

  void addArticle(ArticleModel article) {
    if (state.any((a) => a.title == article.title)) return;
    state = [...state, article];
  }

  void removeArticle(ArticleModel article) {
    state = state.where((a) => a.title != article.title).toList();
  }

  bool isBookmarked(ArticleModel article) {
    return state.any((a) => a.title == article.title);
  }
}

final bookmarkedArticlesProvider = StateNotifierProvider<BookmarkedArticlesNotifier, List<ArticleModel>>((ref) {
  return BookmarkedArticlesNotifier();
});
