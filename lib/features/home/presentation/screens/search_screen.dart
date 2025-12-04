import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_ojt_project/features/article/data/article_model.dart';
import 'package:tes_ojt_project/features/article/data/article_repository.dart';
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  List<ArticleModel> _articles = [];
  bool _isLoading = false;
  String _statusMessage = "Type a topic to search news";

  void _performSearch() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _statusMessage = "Searching...";
      });

      try {
        final results = await ArticleRepository().searchArticles(_searchController.text);
        setState(() {
          _articles = results;
          _isLoading = false;
          if (results.isEmpty) {
            _statusMessage = "No news found for this topic.";
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _statusMessage = "Error: Could not fetch news.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search News")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search Topic (e.g. Bitcoin)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a keyword';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
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
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                  ? Center(child: Text(_statusMessage, style: const TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == article.title);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/article', arguments: article);
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: article.urlToImage != null
                            ? Image.network(
                          article.urlToImage!,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 50),
                        )
                            : const Icon(Icons.article, size: 50),
                        title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(article.publishedAt ?? "", style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
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
