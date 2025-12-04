// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing flutter_riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the article model.
import 'package:tes_ojt_project/features/article/data/article_model.dart';
// Importing the article repository to fetch data.
import 'package:tes_ojt_project/features/article/data/article_repository.dart';
// Importing the provider for bookmarked articles.
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';

// Defining the SearchScreen as a ConsumerStatefulWidget to interact with Riverpod providers.
class SearchScreen extends ConsumerStatefulWidget {
  // Constructor for SearchScreen widget.
  const SearchScreen({super.key});

  // Creating the state for the SearchScreen.
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

// State class for SearchScreen.
class _SearchScreenState extends ConsumerState<SearchScreen> {
  // A global key to uniquely identify the Form widget and allow validation.
  final _formKey = GlobalKey<FormState>();
  // A controller for the search text field.
  final _searchController = TextEditingController();
  // A list to hold the search results.
  List<ArticleModel> _articles = [];
  // A boolean to track the loading state.
  bool _isLoading = false;
  // A string to display the status of the search.
  String _statusMessage = "Type a topic to search news";

  // Function to perform the search.
  void _performSearch() async {
    // Checking if the form is valid.
    if (_formKey.currentState!.validate()) {
      // Setting the state to show the loading indicator.
      setState(() {
        _isLoading = true;
        _statusMessage = "Searching...";
      });

      try {
        // Fetching the articles from the repository.
        final results = await ArticleRepository().searchArticles(_searchController.text);
        // Updating the state with the search results.
        setState(() {
          _articles = results;
          _isLoading = false;
          // Updating the status message if no results are found.
          if (results.isEmpty) {
            _statusMessage = "No news found for this topic.";
          }
        });
      } catch (e) {
        // Handling any errors during the search.
        setState(() {
          _isLoading = false;
          _statusMessage = "Error: Could not fetch news.";
        });
      }
    }
  }

  // Building the UI for the SearchScreen.
  @override
  Widget build(BuildContext context) {
    // Returning a Scaffold, which provides a basic layout structure.
    return Scaffold(
      // Defining the AppBar at the top of the screen.
      appBar: AppBar(title: const Text("Search News")),
      // Defining the body of the Scaffold.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Creating a form for the search input.
            Form(
              key: _formKey,
              child: Row(
                children: [
                  // Expanding the text field to fill the available space.
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search Topic (e.g. Bitcoin)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      // Validating the input to ensure it's not empty.
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Adding a button to trigger the search.
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text("GO"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Expanding the list view to fill the remaining space.
            Expanded(
              // Showing a loading indicator while searching.
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  // Showing a status message if there are no articles.
                  : _articles.isEmpty
                  ? Center(child: Text(_statusMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)))
                  // Building the list of articles.
                  : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  // Checking if the article is bookmarked.
                  final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == article.title);
                  // Making the list item tappable to navigate to the article details.
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/article', arguments: article);
                    },
                    // Displaying each article in a Card widget.
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        // Displaying the article image if available.
                        leading: article.urlToImage != null
                            ? Image.network(
                          article.urlToImage!,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50),
                        )
                            : const Icon(Icons.article, size: 50),
                        // Displaying the article title.
                        title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        // Displaying the publication date.
                        subtitle: Text(article.publishedAt ?? "", style: const TextStyle(fontSize: 12)),
                        // Adding a bookmark button to each article.
                        trailing: IconButton(
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          ),
                          onPressed: () {
                            // Getting the bookmarked articles notifier.
                            final bookmarkedArticlesNotifier = ref.read(bookmarkedArticlesProvider.notifier);
                            // Adding or removing the article from bookmarks.
                            if (isBookmarked) {
                              bookmarkedArticlesNotifier.removeArticle(article);
                            } else {
                              bookmarkedArticlesNotifier.addArticle(article);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
