import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// استيراد الكلاسات التانية (تأكد من تعديل المسارات حسب مشروعك)

import 'newsCubit.dart';
import 'newsModel.dart';
import 'newsState.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أخبار العالم',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // استخدام BlocBuilder للتحكم في معطيات الشاشة حسب الحالة (State)
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {

          // 1. حالة التحميل (Loading)
          if (state is NewsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. حالة الفشل أو الخطأ (Error)
          else if (state is NewsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // إعادة محاولة جلب البيانات عند الضغط على الزر
                      context.read<NewsCubit>().getNews();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          // 3. حالة النجاح وعرض البيانات (Success)
          else if (state is NewsSuccessState) {
            // لو الـ API رجع لستة فاضية مفيهاش أخبار
            if (state.articles.isEmpty) {
              return const Center(child: Text('لا توجد أخبار حالياً'));
            }

            // عرض الأخبار في قائمة مرنة
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final Articles = state.articles[index];
                return _buildNewsCard(Articles); // كارت مخصص لكل خبر
              },
            );
          }

          // الحالة الافتراضية (Initial State مثلاً)
          return const Center(child: Text('اضغط لجلب الأخبار'));
        },
      ),
    );
  }

  /// أداة مخصصة (Widget) لرسم كارت الخبر الواحد بشكل منسق
  Widget _buildNewsCard(Article Articles) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض صورة الخبر (مع معالجة لو الصورة مش موجودة)
          if (Articles.imageUrl != null && Articles.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                Articles.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(), // تختفي لو الرابط بايظ
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الخبر
                Text(
                  Articles.title ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // لقص النص لو طويل
                  textDirection: TextDirection.rtl, // لضبط القراءة باللغة العربية
                ),
                const SizedBox(height: 8),

                // وصف الخبر أو تفاصيل بسيطة
                if (Articles.description != null)
                  Text(
                    Articles.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}