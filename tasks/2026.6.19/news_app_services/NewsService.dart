import 'dart:convert';
import 'package:http/http.dart' as http;

import 'newsModel.dart';


class NewsService {
  // الرابط الأساسي للـ API (مثال باستخدام NewsAPI الشهير)
  final String _baseUrl = "https://newsapi.org/v2";
  final String _apiKey = "044b4316c4b84857adb25000c2bcae64";

  /// دالة جلب الأخبار العاجلة
  Future<List<Article>> fetchTopHeadlines({String category = 'general'}) async {
    // 1. تحديد الرابط بالكامل مع الـ Query Parameters
    final Uri url = Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey');

    try {
      // 2. إرسال طلب GET للسيرفر
      final http.Response response = await http.get(url);

      // 3. التحقق من نجاح الطلب (Status Code 200 يعني تمام)
      if (response.statusCode == 200) {
        // فك تشفير النص القادم من السيرفر وتحويله لـ Map
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // جلب قائمة الأخبار من داخل الـ JSON (غالباً بيكون اسمها 'articles')
        final List<dynamic> articlesJson = jsonData['articles'];

        // 4. تحويل الـ List dynamic إلى List<Article> باستخدام الـ Model
        List<Article> articlesList = articlesJson
            .map((articleMap) => Article.fromJson(articleMap))
            .toList();

        return articlesList;
      } else {
        // في حال وجود خطأ من السيرفر (مثلاً الـ Token غلط أو السيرفر واقع)
        throw Exception('فشل في تحميل الأخبار: كود الخطأ ${response.statusCode}');
      }
    } catch (e) {
      // في حال حدوث خطأ في الاتصال بالإنترنت نفسه
      throw Exception('حدث خطأ أثناء الاتصال بالشبكة: $e');
    }
  }
}