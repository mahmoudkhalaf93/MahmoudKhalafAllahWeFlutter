import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MenuCubit() : super(MenuInitial());

  Future<void> loadCategories() async {
    emit(MenuLoading());
    try {
      final snapshot = await _firestore.collection('cat').get();
      final categories = snapshot.docs.map((doc) => CategoryModel.fromJson(doc.data(), doc.id)).toList();
      
      if (categories.isNotEmpty) {
        final itemsSnapshot = await _firestore.collection('cat').doc(categories[0].firebaseId).collection('items').get();
        final items = itemsSnapshot.docs.map((doc) => ItemModel.fromJson(doc.data(), doc.id)).toList();
        emit(MenuLoaded(categories: categories, items: items, selectedCategoryIndex: 0));
      } else {
        emit(MenuLoaded(categories: const [], items: const []));
      }
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }

  Future<void> selectCategory(int index) async {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      try {
        final catId = currentState.categories[index].firebaseId!;
        final itemsSnapshot = await _firestore.collection('cat').doc(catId).collection('items').get();
        final items = itemsSnapshot.docs.map((doc) => ItemModel.fromJson(doc.data(), doc.id)).toList();
        emit(MenuLoaded(
          categories: currentState.categories,
          items: items,
          selectedCategoryIndex: index,
        ));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    }
  }

  // Helper to find an item's original price by name across all categories
  Future<double?> findOriginalPrice(String itemName) async {
    try {
      final categoriesSnapshot = await _firestore.collection('cat').get();
      for (var catDoc in categoriesSnapshot.docs) {
        final itemsSnapshot = await catDoc.reference.collection('items').get();
        for (var itemDoc in itemsSnapshot.docs) {
          if (itemDoc.data()['name'].toString().toLowerCase().contains(itemName.toLowerCase())) {
            return (itemDoc.data()['price'] as num?)?.toDouble();
          }
        }
      }
    } catch (e) {
      print("Error finding original price: $e");
    }
    return null;
  }
}
