// Defining the structure for a news article.
class ArticleModel {
  // The title of the article, which is always required.
  final String title;
  // A short description of the article, which can be null.
  final String? description;
  // The URL to the full article, which can be null.
  final String? url;
  // The URL for the article's main image, which can be null.
  final String? urlToImage;
  // The author of the article, which can be null.
  final String? author;
  // The date the article was published, which can be null.
  final String? publishedAt;
  // The content of the article, which can be null.
  final String? content;

  // Constructor for creating an ArticleModel instance.
  ArticleModel({
    // Title is a required parameter.
    required this.title,
    // These parameters are optional.
    this.description,
    this.url,
    this.urlToImage,
    this.author,
    this.publishedAt,
    this.content,
  });

  // A factory constructor to create an ArticleModel from a JSON object.
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Returning a new ArticleModel instance from the JSON data.
    return ArticleModel(
      // Providing a default value if the title is null.
      title: json['title'] ?? "No Title Available",
      // These fields are taken directly from the JSON.
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      // Providing a default value if the author is null.
      author: json['author'] ?? "Unknown Source",
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}
