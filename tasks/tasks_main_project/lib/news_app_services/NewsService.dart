import 'dart:convert';
import 'package:http/http.dart' as http;

import 'newsModel.dart';


class NewsService {

  final String _baseUrl = "https://newsapi.org/v2";
  final String _apiKey = "044b4316c4b84857adb25000c2bcae64";

  Future<List<Article>> fetchTopHeadlines({String category = 'general'}) async {

    final Uri url = Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey');

    try {

      final http.Response response = await http.get(url);


      if (response.statusCode == 200) {

        final Map<String, dynamic> jsonData = jsonDecode(response.body);


        final List<dynamic> articlesJson = jsonData['articles'];


        List<Article> articlesList = articlesJson
            .map((articleMap) => Article.fromJson(articleMap))
            .toList();

        return articlesList;
      } else {

        throw Exception('فشل في تحميل الأخبار: كود الخطأ ${response.statusCode}');
      }
    } catch (e) {

      throw Exception('حدث خطأ أثناء الاتصال بالشبكة: $e');
    }
  }
}