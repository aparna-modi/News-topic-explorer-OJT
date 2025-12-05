// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing flutter_riverpod for state management.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importing flutter_tts for text-to-speech functionality.
import 'package:flutter_tts/flutter_tts.dart';
// Importing the article model to structure the data.
import 'package:tes_ojt_project/features/article/data/article_model.dart';
// Importing the provider for bookmarked articles.
import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';
// Importing the web view screen to display the full article.
import 'package:tes_ojt_project/features/article_web_view/presentation/article_web_view_screen.dart';

// A ConsumerStatefulWidget that displays the details of a single article.
class ArticleScreen extends ConsumerStatefulWidget {
  // The article to be displayed.
  final ArticleModel article;

  // Constructor for the ArticleScreen, requiring an article.
  const ArticleScreen({super.key, required this.article});

  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      final textToSpeak = widget.article.content ?? widget.article.description ?? 'No content available to read.';
      if (textToSpeak != 'No content available to read.') {
        setState(() {
          _isPlaying = true;
        });
        await _flutterTts.speak(textToSpeak);
      }
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  // Building the UI for the ArticleScreen.
  @override
  Widget build(BuildContext context) {
    // Checking if the current article is bookmarked.
    final isBookmarked = ref.watch(bookmarkedArticlesProvider).any((b) => b.title == widget.article.title);
    // Returning a Scaffold, which provides a basic layout structure.
    return Scaffold(
      // Defining the AppBar at the top of the screen.
      appBar: AppBar(
        // Setting the title of the AppBar to the article title.
        title: Text(widget.article.title),
        // Adding action buttons to the AppBar.
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline),
            onPressed: _togglePlay,
          ),
          // Adding a bookmark button.
          IconButton(
            icon: Icon(
              // Changing the icon based on whether the article is bookmarked.
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              // Getting the bookmarked articles notifier.
              final bookmarkedArticlesNotifier = ref.read(bookmarkedArticlesProvider.notifier);
              // Adding or removing the article from bookmarks.
              if (isBookmarked) {
                bookmarkedArticlesNotifier.removeArticle(widget.article);
              } else {
                bookmarkedArticlesNotifier.addArticle(widget.article);
              }
            },
          ),
        ],
      ),
      // Defining the body of the Scaffold.
      body: SingleChildScrollView(
        // Adding padding around the content.
        padding: const EdgeInsets.all(16.0),
        // Arranging the content in a vertical column.
        child: Column(
          // Aligning the content to the start of the column.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the article image if it exists.
            if (widget.article.urlToImage != null)
              Image.network(
                widget.article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Handling image loading errors.
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.broken_image, size: 40.0)),
                  );
                },
              ),
            const SizedBox(height: 16.0),
            // Displaying the article title.
            Text(
              widget.article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 8.0),
            // Displaying the author and publication date.
            Text(
              "By ${widget.article.author ?? 'Unknown'} | ${widget.article.publishedAt ?? 'No date'}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            // Displaying the article content or description.
            Text(
              widget.article.content ?? widget.article.description ?? 'No content available.',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // Displaying a button to view the full story if a URL is available.
            if (widget.article.url != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigating to the web view screen.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleWebViewScreen(url: widget.article.url!),
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
