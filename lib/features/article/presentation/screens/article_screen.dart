import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleScreen extends ConsumerWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Screen'),
      ),
      body: const Center(
        child: Text('This is the Article Screen.'),

        // child : Column(
        //
        // ),

      ),
    );
  }
}
