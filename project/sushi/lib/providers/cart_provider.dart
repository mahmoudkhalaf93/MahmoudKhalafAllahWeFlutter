import 'package:flutter/material.dart';
import '../models/item_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, ItemModel> _items = {};

  Map<String, ItemModel> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += (item.price ?? 0.0) * (item.quantity ?? 1);
    });
    return total;
  }

  void addItem(ItemModel item) {
    if (_items.containsKey(item.firebaseId)) {
      // Increase quantity
      _items.update(
        item.firebaseId!,
        (existing) => ItemModel(
          name: existing.name,
          nameAr: existing.nameAr,
          description: existing.description,
          descriptionAr: existing.descriptionAr,
          price: existing.price,
          image: existing.image,
          quantity: (existing.quantity ?? 1) + 1,
          firebaseId: existing.firebaseId,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        item.firebaseId!,
        () => ItemModel(
          name: item.name,
          nameAr: item.nameAr,
          description: item.description,
          descriptionAr: item.descriptionAr,
          price: item.price,
          image: item.image,
          quantity: 1,
          firebaseId: item.firebaseId,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String firebaseId) {
    _items.remove(firebaseId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
