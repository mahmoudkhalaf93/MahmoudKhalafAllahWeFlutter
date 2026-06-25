import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {

          if (state is NewsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

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
                      context.read<NewsCubit>().getNews();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          else if (state is NewsSuccessState) {
            if (state.articles.isEmpty) {
              return const Center(child: Text('لا توجد أخبار حالياً'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final Articles = state.articles[index];
                return _buildNewsCard(Articles);
              },
            );
          }

          return const Center(child: Text('اضغط لجلب الأخبار'));
        },
      ),
    );
  }

  Widget _buildNewsCard(Article Articles) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Articles.imageUrl != null && Articles.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                Articles.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Articles.title ?? 'بدون عنوان',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),

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