import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/item_model.dart';
import '../../models/order_model.dart';
import '../../models/restaurant_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartCubit() : super(const CartState()) {
    _loadCartFromFirestore();
  }

  String? get _uid => _auth.currentUser?.uid;

  Future<void> _loadCartFromFirestore() async {
    if (_uid == null) return;
    try {
      final snapshot = await _firestore.collection('users').doc(_uid).collection('mycart').get();
      final items = <String, ItemModel>{};
      for (var doc in snapshot.docs) {
        items[doc.id] = ItemModel.fromJson(doc.data(), doc.id);
      }
      emit(state.copyWith(items: items));
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  Future<void> addItem(ItemModel item) async {
    if (_uid == null) return;
    final updatedItems = Map<String, ItemModel>.from(state.items);
    ItemModel newItem;

    if (updatedItems.containsKey(item.firebaseId)) {
      newItem = ItemModel(
        name: updatedItems[item.firebaseId]!.name,
        nameAr: updatedItems[item.firebaseId]!.nameAr,
        description: updatedItems[item.firebaseId]!.description,
        descriptionAr: updatedItems[item.firebaseId]!.descriptionAr,
        price: updatedItems[item.firebaseId]!.price,
        image: updatedItems[item.firebaseId]!.image,
        quantity: (updatedItems[item.firebaseId]!.quantity ?? 1) + 1,
        firebaseId: item.firebaseId,
      );
    } else {
      newItem = ItemModel(
        name: item.name,
        nameAr: item.nameAr,
        description: item.description,
        descriptionAr: item.descriptionAr,
        price: item.price,
        image: item.image,
        quantity: 1,
        firebaseId: item.firebaseId,
      );
    }

    try {
      await _firestore.collection('users').doc(_uid).collection('mycart').doc(newItem.firebaseId).set(newItem.toJson());
      updatedItems[newItem.firebaseId!] = newItem;
      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> updateQuantity(String firebaseId, int delta) async {
    if (_uid == null || !state.items.containsKey(firebaseId)) return;
    final currentItem = state.items[firebaseId]!;
    int newQuantity = (currentItem.quantity ?? 1) + delta;

    if (newQuantity <= 0) {
      await removeItem(firebaseId);
    } else {
      final updatedItem = ItemModel(
        name: currentItem.name,
        nameAr: currentItem.nameAr,
        description: currentItem.description,
        descriptionAr: currentItem.descriptionAr,
        price: currentItem.price,
        image: currentItem.image,
        quantity: newQuantity,
        firebaseId: firebaseId,
      );
      await _firestore.collection('users').doc(_uid).collection('mycart').doc(firebaseId).set(updatedItem.toJson());
      final updatedItems = Map<String, ItemModel>.from(state.items);
      updatedItems[firebaseId] = updatedItem;
      emit(state.copyWith(items: updatedItems));
    }
  }

  Future<void> removeItem(String firebaseId) async {
    if (_uid == null) return;
    try {
      await _firestore.collection('users').doc(_uid).collection('mycart').doc(firebaseId).delete();
      final updatedItems = Map<String, ItemModel>.from(state.items);
      updatedItems.remove(firebaseId);
      emit(state.copyWith(items: updatedItems));
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  Future<void> calculateDelivery() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final doc = await _firestore.collection('restaurants').doc('sushir12').get();
      if (!doc.exists) return;
      final restaurant = RestaurantModel.fromJson(doc.data()!);
      if (restaurant.branches == null || restaurant.branches!.isEmpty) return;

      double minDistance = double.infinity;
      for (var branch in restaurant.branches!) {
        if (branch.location != null) {
          double distance = Geolocator.distanceBetween(
            position.latitude, position.longitude,
            branch.location!.latitude, branch.location!.longitude,
          );
          if (distance < minDistance) minDistance = distance;
        }
      }
      double fee = 15.0 + (4.0 * (minDistance / 1000.0));
      emit(state.copyWith(deliveryFee: fee));
    } catch (e) {
      print("Error calculating delivery: $e");
    }
  }

  Future<String?> placeOrder() async {
    if (_uid == null || state.items.isEmpty) return null;

    try {
      final position = await Geolocator.getCurrentPosition();
      final order = OrderModel(
        id: '', 
        userId: _uid!,
        items: state.items.values.toList(),
        status: OrderStatus.pending,
        subtotal: state.subtotal,
        deliveryFee: state.deliveryFee,
        totalAmount: state.totalAmount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deliveryLocation: GeoPoint(position.latitude, position.longitude),
      );

      final docRef = await _firestore.collection('orders').add(order.toJson());
      await clear();
      return docRef.id;
    } catch (e) {
      print("Error placing order: $e");
      return null;
    }
  }

  Future<void> clear() async {
    if (_uid == null) return;
    try {
      final snapshot = await _firestore.collection('users').doc(_uid).collection('mycart').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      emit(const CartState(items: {}, deliveryFee: 0.0));
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }
}
