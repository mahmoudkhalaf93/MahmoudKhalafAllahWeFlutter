
import 'newsModel.dart';


abstract class NewsState {}


class NewsInitialState extends NewsState {}


class NewsLoadingState extends NewsState {}


class NewsSuccessState extends NewsState {
  final List<Article> articles;
  NewsSuccessState(this.articles);
}


class NewsErrorState extends NewsState {
  final String errorMessage;
  NewsErrorState(this.errorMessage);
}