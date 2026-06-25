import 'package:flutter_bloc/flutter_bloc.dart';

import 'NewsService.dart';
import 'newsState.dart';
class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitialState());

  final NewsService _newsService = NewsService();

  Future<void> getNews({String category = 'general'}) async {
    emit(NewsLoadingState());

    try {
      final articles = await _newsService.fetchTopHeadlines(category: category);

      emit(NewsSuccessState(articles));
    } catch (e) {
      emit(NewsErrorState(e.toString().replaceAll('Exception:', '')));
    }
  }
}