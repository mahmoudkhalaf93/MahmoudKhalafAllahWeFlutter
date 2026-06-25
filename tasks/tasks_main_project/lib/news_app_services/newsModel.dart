class Article {
  final String? sourceName;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final String? publishedAt;
  final String? content;

  Article({
    this.sourceName,
    this.author,
    required this.title,
    required this.description,
    this.url,
    required this.imageUrl,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      sourceName: json['source'] != null ? json['source']['name'] : 'مصدر مجهول',

      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],

      imageUrl: json['urlToImage'],

      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}