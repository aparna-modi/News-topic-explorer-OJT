// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:tes_ojt_project/features/article/data/article_model.dart';
// import 'package:tes_ojt_project/features/article/presentation/providers/bookmarked_articles_provider.dart';
// import 'package:tes_ojt_project/features/article/presentation/screens/article_screen.dart';
//
// class SavedScreen extends ConsumerStatefulWidget {
//   const SavedScreen({super.key});
//
//   @override
//   ConsumerState<SavedScreen> createState() => _SavedScreenState();
// }
//
// class _SavedScreenState extends ConsumerState<SavedScreen> {
//   final FlutterTts _flutterTts = FlutterTts();
//   ArticleModel? _currentlyPlaying;
//
//   @override
//   void initState() {
//     super.initState();
//     _flutterTts.setCompletionHandler(() {
//       if (mounted) {
//         setState(() {
//           _currentlyPlaying = null;
//         });
//       }
//     });
//   }
//
//   void _togglePlay(ArticleModel article) async {
//     if (_currentlyPlaying == article) {
//       await _flutterTts.stop();
//       setState(() {
//         _currentlyPlaying = null;
//       });
//     } else {
//       await _flutterTts.stop();
//       final textToSpeak = article.content ?? article.description ?? 'No content available to read.';
//       if (textToSpeak != 'No content available to read.') {
//         setState(() {
//           _currentlyPlaying = article;
//         });
//         await _flutterTts.speak(textToSpeak);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _flutterTts.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bookmarkedArticles = ref.watch(bookmarked_articles_provider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saved Articles'),
//       ),
//       body: bookmarkedArticles.isEmpty
//           ? const Center(
//               child: Text(
//                 'No saved articles yet.',
//                 style: TextStyle(color: Colors.grey, fontSize: 18.0),
//               ),
//             )
//           : ListView.builder(
//               itemCount: bookmarkedArticles.length,
//               itemBuilder: (context, index) {
//                 final article = bookmarkedArticles[index];
//                 final isPlaying = _currentlyPlaying == article;
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ArticleScreen(article: article),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(12.0),
//                       leading: article.urlToImage != null
//                           ? Image.network(
//                               article.urlToImage!,
//                               width: 80,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(Icons.broken_image, size: 50);
//                               },
//                             )
//                           : const Icon(Icons.article, size: 50),
//                       title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
//                       subtitle: Text(
//                         article.description ?? '',
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline),
//                             color: Theme.of(context).primaryColor,
//                             onPressed: () => _togglePlay(article),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               ref.read(bookmarked_articles_provider.notifier).removeArticle(article);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
