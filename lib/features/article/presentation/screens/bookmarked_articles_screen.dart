// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing flutter_riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the provider for bookmarked articles.
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';

// A ConsumerWidget that displays a list of bookmarked articles.
class BookmarkedArticlesScreen extends ConsumerWidget {
  // Constructor for the BookmarkedArticlesScreen.
  const BookmarkedArticlesScreen({super.key});

  // Building the UI for the BookmarkedArticlesScreen.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the bookmarkedArticlesProvider to get the list of bookmarked articles.
    final bookmarkedArticles = ref.watch(bookmarkedArticlesProvider);

    // Returning a Scaffold, which provides a basic layout structure.
    return Scaffold(
      // Defining the AppBar at the top of the screen.
      appBar: AppBar(
        // Setting the title of the AppBar.
        title: const Text('Bookmarked Articles'),
      ),
      // Defining the body of the Scaffold.
      body: bookmarkedArticles.isEmpty
          // Displaying a message if there are no bookmarked articles.
          ? const Center(
              child: Text('No bookmarked articles yet.'),
            )
          // Displaying the list of bookmarked articles.
          : ListView.builder(
              // Setting the number of items in the list.
              itemCount: bookmarkedArticles.length,
              // Building each item in the list.
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                // Making the card tappable to navigate to the article details.
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/article', arguments: article);
                  },
                  // Displaying each article in a Card widget.
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Displaying the article image if available.
                          if (article.urlToImage != null)
                            Image.network(
                              article.urlToImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // Handling image loading errors.
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  height: 200,
                                  child: Center(child: Icon(Icons.broken_image, size: 40.0,)),
                                );
                              },
                            ),
                          const SizedBox(height: 8.0),
                          // Displaying the article title.
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          // Displaying the article description.
                          Text(
                            article.description ?? 'No description available.',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          // Adding a button to delete the article from bookmarks.
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(bookmarkedArticlesProvider.notifier).removeArticle(article);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
