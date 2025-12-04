// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing flutter_riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing the article model.
import 'package:tes_ojt_project/features/article/data/article_model.dart';
// Importing the article screen.
import 'package:tes_ojt_project/features/article/presentation/screens/article_screen.dart';
// Importing the bookmarked articles screen.
import 'package:tes_ojt_project/features/article/presentation/screens/bookmarked_articles_screen.dart';
// Importing the home screen.
import 'package:tes_ojt_project/features/home/presentation/screens/home_screen.dart';
// Importing the search screen.
import 'package:tes_ojt_project/features/home/presentation/screens/search_screen.dart';

// Main function, the entry point of the application.
void main() {
  // Running the app within a ProviderScope to enable Riverpod state management.
  runApp(const ProviderScope(child: MyAppu()));
}

// Defining the root widget of the application.
class MyAppu extends StatelessWidget {
  // Constructor for MyAppu widget.
  const MyAppu({super.key});

  // Build method to describe the user interface.
  @override
  Widget build(BuildContext context) {
    // Returning a MaterialApp, which is the root of the app's widget tree.
    return MaterialApp(
      // Setting the title of the application.
      title: 'Flutter Demo',
      // Hiding the debug banner.
      debugShowCheckedModeBanner: false,
      // Defining the theme of the application.
      theme: ThemeData(
        // Setting the color scheme from a seed color.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Enabling Material 3 design.
        useMaterial3: true,
      ),
      // Setting the initial route of the application.
      initialRoute: '/',
      // Defining the named routes for navigation.
      routes: {
        // Route for the home screen.
        '/': (context) => const HomeScreen(),
        // Route for the search screen.
        '/search': (context) => const SearchScreen(),
        // Route for the bookmarked articles screen.
        '/bookmarked': (context) => const BookmarkedArticlesScreen(),
      },
      // Handling dynamic route generation.
      onGenerateRoute: (settings) {
        // Checking if the route is for the article screen.
        if (settings.name == '/article') {
          // Extracting the arguments passed to the route.
          final args = settings.arguments as ArticleModel;
          // Returning a MaterialPageRoute for the article screen.
          return MaterialPageRoute(
            builder: (context) {
              // Building the ArticleScreen with the provided article data.
              return ArticleScreen(article: args);
            },
          );
        }
        // Returning null if the route is not handled.
        return null;
      },
    );
  }
}
