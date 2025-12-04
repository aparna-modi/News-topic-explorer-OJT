// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing flutter_riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the provider for all articles.
import 'package:tes_ojt_project/features/article/presentation/providers/all_articles_provider.dart';
// Importing the article providers.
import 'package:tes_ojt_project/features/article/presentation/providers/article_providers.dart';
// Importing the provider for bookmarked articles.
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';

// Defining the HomeScreen as a ConsumerStatefulWidget to interact with Riverpod providers.
class HomeScreen extends ConsumerStatefulWidget {
  // Constructor for HomeScreen widget.
  const HomeScreen({super.key});

  // Creating the state for the HomeScreen.
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

// State class for HomeScreen, with SingleTickerProviderStateMixin for TabController.
class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  // Declaring a TabController to manage the tabs.
  late TabController _tabController;
  // Defining the list of categories for the tabs.
  final List<String> _categories = [
    'all',
    'technology',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
  ];

  // Initializing the state of the widget.
  @override
  void initState() {
    super.initState();
    // Initializing the TabController with the number of categories.
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  // Disposing of the TabController when the widget is removed from the tree.
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Building the UI for the HomeScreen.
  @override
  Widget build(BuildContext context) {
    // Returning a Scaffold, which provides a basic layout structure.
    return Scaffold(
      // Defining the AppBar at the top of the screen.
      appBar: AppBar(
        // Setting the title of the AppBar.
        title: const Text('News'),
        // Adding action buttons to the AppBar.
        actions: [
          // Adding a search button.
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigating to the search screen when pressed.
              Navigator.pushNamed(context, '/search');
            },
          ),
          // Adding a bookmark button.
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              // Navigating to the bookmarked articles screen when pressed.
              Navigator.pushNamed(context, '/bookmarked');
            },
          ),
        ],
        // Setting the elevation of the AppBar.
        elevation: 6,
        // Adding a TabBar below the AppBar.
        bottom: TabBar(
          // Assigning the TabController to the TabBar.
          controller: _tabController,
          // Making the TabBar scrollable.
          isScrollable: true,
          // Creating a list of Tab widgets from the categories.
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      // Defining the body of the Scaffold.
      body: TabBarView(
        // Assigning the TabController to the TabBarView.
        controller: _tabController,
        // Creating a list of widgets for each tab.
        children: _categories.map((category) {
          // Watching the appropriate provider based on the selected category.
          final articlesAsyncValue = category == 'all'
              ? ref.watch(allArticlesProvider)
              : ref.watch(topHeadlinesProvider(category));

          // Handling the different states of the async data (data, loading, error).
          return articlesAsyncValue.when(
            // When data is available, build the list of articles.
            data: (articles) {
              return ListView.builder(
                // Setting the number of items in the list.
                itemCount: articles.length,
                // Building each item in the list.
                itemBuilder: (context, index) {
                  final article = articles[index];
                  // Checking if the article is bookmarked.
                  final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == article.title);
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
                            // Adding a bookmark button to each article.
                            IconButton(
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            // Showing a loading indicator while fetching data.
            loading: () => const Center(child: CircularProgressIndicator()),
            // Showing an error message if data fetching fails.
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        }).toList(),
      ),
    );
  }
}
