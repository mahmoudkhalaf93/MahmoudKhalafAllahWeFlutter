import 'package:equatable/equatable.dart';
import '../../models/item_model.dart';

class CartState extends Equatable {
  final Map<String, ItemModel> items;
  final double deliveryFee;

  const CartState({
    this.items = const {},
    this.deliveryFee = 0.0,
  });

  double get subtotal {
    double total = 0.0;
    items.forEach((key, item) {
      total += (item.price ?? 0.0) * (item.quantity ?? 1);
    });
    return total;
  }

  double get totalAmount => subtotal + deliveryFee;

  int get itemCount => items.length;

  CartState copyWith({
    Map<String, ItemModel>? items,
    double? deliveryFee,
  }) {
    return CartState(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  @override
  List<Object?> get props => [items, deliveryFee];
}
