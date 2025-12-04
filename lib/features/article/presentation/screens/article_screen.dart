import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_ojt_project/features/article/data/article_model.dart';
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';
import 'package:tes_ojt_project/features/article_web_view/presentation/article_web_view_screen.dart';

class ArticleScreen extends ConsumerWidget {
  final ArticleModel article;

  const ArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == article.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              final bookmarkedArticlesNotifier = ref.read(bookmarkedArticlesProvider.notifier);
              if (isBookmarked) {
                bookmarkedArticlesNotifier.removeArticle(article);
              } else {
                bookmarkedArticlesNotifier.addArticle(article);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.broken_image, size: 40.0)),
                  );
                },
              ),
            const SizedBox(height: 16.0),
            Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'By ${article.author ?? 'Unknown'} | ${article.publishedAt ?? 'No date'}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              article.content ?? article.description ?? 'No content available.',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            if (article.url != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleWebViewScreen(url: article.url!),
                      ),
                    );
                  },
                  child: const Text('Show Full Story'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
