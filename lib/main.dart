import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_ojt_project/features/article/presentation/screens/article_screen.dart';
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

      //stops showing the debug red color banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/article': (context) => const ArticleScreen(),
        // '/search': (context) => const SearchScreen(),
      },
    );
  }
}
