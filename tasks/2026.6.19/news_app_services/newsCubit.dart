import 'package:flutter_bloc/flutter_bloc.dart';

import 'NewsService.dart';
import 'newsState.dart';
// مسار ملف الحالات اللي فوق

class NewsCubit extends Cubit<NewsState> {
  // 1. نمرر حالة البداية للكوبيت (Initial State)
  NewsCubit() : super(NewsInitialState());

  final NewsService _newsService = NewsService();

  /// 2. دالة جلب الأخبار
  Future<void> getNews({String category = 'general'}) async {
    // أول ما الدالة تبدأ، بنبعت للشاشة حالة "التحميل"
    emit(NewsLoadingState());

    try {
      // نطلب البيانات من السيرفر
      final articles = await _newsService.fetchTopHeadlines(category: category);

      // لو جت تمام، بنبعت حالة "النجاح" ومعاها لستة الأخبار
      emit(NewsSuccessState(articles));
    } catch (e) {
      // لو حصل خطأ، بنبعت حالة "الخطأ" ومعاها الرسالة
      emit(NewsErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }
}