
import 'newsModel.dart';

// الكلاس الأساسي
abstract class NewsState {}

// 1. حالة البداية (قبل ما نعمل أي حاجة)
class NewsInitialState extends NewsState {}

// 2. حالة التحميل (الـ Loading اللي بنظهر فيها الدائرة بتلف)
class NewsLoadingState extends NewsState {}

// 3. حالة النجاح (لما الأخبار تيجي بالسلامة ونعرضها)
class NewsSuccessState extends NewsState {
  final List<Article> articles;
  NewsSuccessState(this.articles); // بنشيل الأخبار جوه الحالة دي عشان الشاشة تاخدها
}

// 4. حالة الفشل (لو النت قطع أو حصل مشكلة)
class NewsErrorState extends NewsState {
  final String errorMessage;
  NewsErrorState(this.errorMessage); // بنشيل رسالة الخطأ هنا
}