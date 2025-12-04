import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_ojt_project/features/article/presentation/providers/all_articles_provider.dart';
import 'package:tes_ojt_project/features/article/presentation/providers/article_providers.dart';
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.pushNamed(context, '/bookmarked');
              },
            ),
          ],
        ),
        elevation: 6,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          final articlesAsyncValue = category == 'all'
              ? ref.watch(allArticlesProvider)
              : ref.watch(topHeadlinesProvider(category));

          return articlesAsyncValue.when(
            data: (articles) {
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == article.title);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/article', arguments: article);
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
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
                                    child: Center(child: Icon(Icons.broken_image, size: 40.0,)),
                                  );
                                },
                              ),
                            const SizedBox(height: 8.0),
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              article.description ?? 'No description available.',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        }).toList(),
      ),
    );
  }
}
