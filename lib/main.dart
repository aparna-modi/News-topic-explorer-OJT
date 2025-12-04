import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_ojt_project/features/article/data/article_model.dart';
import 'package:tes_ojt_project/features/article/presentation/screens/article_screen.dart';
import 'package:tes_ojt_project/features/article/presentation/screens/bookmarked_articles_screen.dart';
import 'package:tes_ojt_project/features/home/presentation/screens/home_screen.dart';
import 'package:tes_ojt_project/features/home/presentation/screens/search_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyAppu()));
}
class MyAppu extends StatelessWidget {
  const MyAppu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/bookmarked': (context) => const BookmarkedArticlesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/article') {
          final args = settings.arguments as ArticleModel;
          return MaterialPageRoute(
            builder: (context) {
              return ArticleScreen(article: args);
            },
          );
        }
        return null;
      },
    );
  }
}
