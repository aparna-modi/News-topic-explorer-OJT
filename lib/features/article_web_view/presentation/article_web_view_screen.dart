// Importing necessary packages for Flutter framework.
import 'package:flutter/material.dart';
// Importing the webview_flutter package to display web content.
import 'package:webview_flutter/webview_flutter.dart';

// A StatefulWidget that displays a web page, in this case, the full article.
class ArticleWebViewScreen extends StatefulWidget {
  // The URL of the web page to be displayed.
  final String url;

  // Constructor for the ArticleWebViewScreen, requiring a URL.
  const ArticleWebViewScreen({super.key, required this.url});

  // Creating the state for the ArticleWebViewScreen.
  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

// State class for ArticleWebViewScreen.
class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  // Declaring a controller for the WebView.
  late final WebViewController _controller;

  // Initializing the state of the widget.
  @override
  void initState() {
    super.initState();
    // Initializing the WebView controller.
    _controller = WebViewController()
      // Enabling JavaScript execution in the WebView.
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Loading the URL from the widget's properties.
      ..loadRequest(Uri.parse(widget.url));
  }

  // Building the UI for the ArticleWebViewScreen.
  @override
  Widget build(BuildContext context) {
    // Returning a Scaffold, which provides a basic layout structure.
    return Scaffold(
      // Defining the AppBar at the top of the screen.
      appBar: AppBar(
        // Setting the title of the AppBar.
        title: const Text('Full Story'),
      ),
      // Defining the body of the Scaffold.
      body: WebViewWidget(controller: _controller),
    );
  }
}
