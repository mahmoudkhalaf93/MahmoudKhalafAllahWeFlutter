import 'package:equatable/equatable.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';

abstract class MenuState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<CategoryModel> categories;
  final List<ItemModel> items;
  final int selectedCategoryIndex;

  MenuLoaded({
    required this.categories,
    required this.items,
    this.selectedCategoryIndex = 0,
  });

  @override
  List<Object?> get props => [categories, items, selectedCategoryIndex];
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);

  @override
  List<Object?> get props => [message];
}
