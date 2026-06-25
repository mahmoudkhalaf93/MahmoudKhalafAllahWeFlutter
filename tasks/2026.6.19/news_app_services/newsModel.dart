class Article {
  final String? sourceName;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? imageUrl; // ده اللي هيقرأ من urlToImage
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

  /// دالة تحويل الـ JSON الفعلي لكائن Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // قراءة اسم المصدر من الخريطة الداخلية 'source' -> 'name'
      sourceName: json['source'] != null ? json['source']['name'] : 'مصدر مجهول',

      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],

      // هنا بنربط الـ imageUrl بـ 'urlToImage' اللي جاي في الـ الـ JSON بتاعك
      imageUrl: json['urlToImage'],

      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}