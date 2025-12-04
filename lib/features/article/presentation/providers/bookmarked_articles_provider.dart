// Importing the Riverpod package for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the article model to structure the data.
import '../../data/article_model.dart';

// A StateNotifier that manages a list of bookmarked articles.
class BookmarkedArticlesNotifier extends StateNotifier<List<ArticleModel>> {
  // The constructor initializes the state with an empty list.
  BookmarkedArticlesNotifier() : super([]);

  // Adds an article to the list of bookmarked articles.
  void addArticle(ArticleModel article) {
    // Checking if the article is already in the list to avoid duplicates.
    if (state.any((a) => a.title == article.title)) return;
    // Creating a new list with the new article added.
    state = [...state, article];
  }

  // Removes an article from the list of bookmarked articles.
  void removeArticle(ArticleModel article) {
    // Creating a new list that excludes the article to be removed.
    state = state.where((a) => a.title != article.title).toList();
  }

  // Checks if a given article is already bookmarked.
  bool isBookmarked(ArticleModel article) {
    // Returning true if the article is found in the list, otherwise false.
    return state.any((a) => a.title == article.title);
  }
}

// A StateNotifierProvider that provides the BookmarkedArticlesNotifier to the app.
final bookmarkedArticlesProvider = StateNotifierProvider<BookmarkedArticlesNotifier, List<ArticleModel>>((ref) {
  // Returning a new instance of the notifier.
  return BookmarkedArticlesNotifier();
});
