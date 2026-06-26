import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/meal_model.dart';
import '../models/driver_model.dart';
import '../models/restaurant_model.dart';
import '../models/offer_model.dart';

class CategoryStats {
  final int mealsCount;
  final int completedOrders;
  final double revenue;

  CategoryStats({
    this.mealsCount = 0,
    this.completedOrders = 0,
    this.revenue = 0,
  });
}

class UserStats {
  final int totalOrders;
  final int cancelledOrders;
  final int completedOrders;
  final int pendingOrders;
  final double totalSpent;

  UserStats({
    this.totalOrders = 0,
    this.cancelledOrders = 0,
    this.completedOrders = 0,
    this.pendingOrders = 0,
    this.totalSpent = 0,
  });
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
    Uint8List fileBytes,
    String folderName,
    String fileName,
  ) async {
    try {
      final Reference ref = _storage.ref().child(folderName).child(fileName);
      final UploadTask uploadTask = ref.putData(fileBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<int> getCategoriesCount() async {
    try {
      var snapshot = await _firestore.collection('cat').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getUsersCount() async {
    try {
      var snapshot = await _firestore.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getOrdersCount() async {
    try {
      var snapshot = await _firestore.collection('orders').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getTotalRevenue() async {
    try {
      var snapshot = await _firestore.collection('orders').get();
      double total = 0;
      for (var doc in snapshot.docs) {
        var data = doc.data();
        final status = (data['status'] ?? '').toString().toLowerCase();
        if (status == 'completed' ||
            status == 'مكتمل' ||
            status == 'delivered' ||
            status == 'تم التوصيل') {
          final amt = data['totalAmount'] ?? data['total'];
          if (amt != null) {
            total += (amt is num)
                ? amt.toDouble()
                : double.tryParse(amt.toString()) ?? 0;
          }
        }
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, CategoryStats>> getCategoryAnalytics() async {
    try {
      final catSnap = await _firestore.collection('cat').get();
      final categoryIds = catSnap.docs.map((d) => d.id).toList();

      final Map<String, int> mealsCountMap = {};
      final Map<String, String> mealNameToCategory = {};
      final Map<String, String> mealIdToCategory = {};

      for (final catId in categoryIds) {
        final mealsSnap = await _firestore
            .collection('cat')
            .doc(catId)
            .collection('items')
            .get();
        mealsCountMap[catId] = mealsSnap.docs.length;

        for (final mealDoc in mealsSnap.docs) {
          final data = mealDoc.data();
          final mealName = (data['name'] ?? '').toString().toLowerCase().trim();
          if (mealName.isNotEmpty) {
            mealNameToCategory[mealName] = catId;
          }
          mealIdToCategory[mealDoc.id] = catId;
        }
      }

      final ordersSnap = await _firestore.collection('orders').get();

      final Map<String, int> completedCountMap = {};
      final Map<String, double> revenueMap = {};
      for (final catId in categoryIds) {
        completedCountMap[catId] = 0;
        revenueMap[catId] = 0;
      }

      for (final orderDoc in ordersSnap.docs) {
        final data = orderDoc.data();
        final status = (data['status'] ?? '').toString().toLowerCase();
        final isCompleted =
            status == 'مكتمل' ||
            status == 'completed' ||
            status == 'delivered' ||
            status == 'تم التوصيل';
        if (!isCompleted) continue;

        final rawItems = data['items'];
        if (rawItems is List && rawItems.isNotEmpty) {
          final Set<String> categoriesInOrder = {};

          for (var item in rawItems) {
            if (item is! Map<String, dynamic>) continue;

            String? resolvedCatId;

            if (item['categoryId'] != null) {
              final cid = item['categoryId'].toString();
              if (categoryIds.contains(cid)) {
                resolvedCatId = cid;
              }
            }

            if (resolvedCatId == null && item['mealId'] != null) {
              resolvedCatId = mealIdToCategory[item['mealId'].toString()];
            }

            if (resolvedCatId == null && item['name'] != null) {
              final name = item['name'].toString().toLowerCase().trim();
              resolvedCatId = mealNameToCategory[name];
            }

            if (resolvedCatId != null) {
              categoriesInOrder.add(resolvedCatId);

              final price = (item['price'] is num)
                  ? (item['price'] as num).toDouble()
                  : double.tryParse(item['price']?.toString() ?? '0') ?? 0;
              final qty = (item['quantity'] is num)
                  ? (item['quantity'] as num).toInt()
                  : 1;
              revenueMap[resolvedCatId] =
                  (revenueMap[resolvedCatId] ?? 0) + (price * qty);
            }
          }

          for (final cid in categoriesInOrder) {
            completedCountMap[cid] = (completedCountMap[cid] ?? 0) + 1;
          }
        }
      }

      final Map<String, CategoryStats> result = {};
      for (final catId in categoryIds) {
        result[catId] = CategoryStats(
          mealsCount: mealsCountMap[catId] ?? 0,
          completedOrders: completedCountMap[catId] ?? 0,
          revenue: revenueMap[catId] ?? 0,
        );
      }

      return result;
    } catch (e) {
      return {};
    }
  }

  Stream<List<CategoryModel>> streamCategories() {
    return _firestore
        .collection('cat')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<UserModel>> streamUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<OrderModel>> streamOrders() {
    return _firestore
        .collection('orders')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<MealModel>> streamMeals(String categoryId) {
    return _firestore
        .collection('cat')
        .doc(categoryId)
        .collection('items')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data(), doc.id, categoryId))
              .toList(),
        );
  }

  Future<List<UserModel>> getUsers() async {
    try {
      var snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      var snapshot = await _firestore.collection('cat').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      var snapshot = await _firestore.collection('orders').get();
      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<MealModel>> getMeals(String categoryId) async {
    try {
      var snapshot = await _firestore
          .collection('cat')
          .doc(categoryId)
          .collection('items')
          .get();
      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data(), doc.id, categoryId))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> getMealsCount(String categoryId) async {
    try {
      var snapshot = await _firestore
          .collection('cat')
          .doc(categoryId)
          .collection('items')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('cat')
          .doc(category.name)
          .set(category.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    try {
      if (category.id != category.name) {
        await _firestore
            .collection('cat')
            .doc(category.name)
            .set(category.toJson());

        final oldMeals = await _firestore
            .collection('cat')
            .doc(category.id)
            .collection('items')
            .get();
        for (final mealDoc in oldMeals.docs) {
          final mealData = mealDoc.data();
          mealData['categoryId'] = category.name;
          await _firestore
              .collection('cat')
              .doc(category.name)
              .collection('items')
              .doc(mealDoc.id)
              .set(mealData);
          await mealDoc.reference.delete();
        }

        await _firestore.collection('cat').doc(category.id).delete();
      } else {
        await _firestore
            .collection('cat')
            .doc(category.id)
            .update(category.toJson());
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final mealsSnap = await _firestore
          .collection('cat')
          .doc(id)
          .collection('items')
          .get();
      for (final doc in mealsSnap.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection('cat').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addMeal(String categoryId, MealModel meal) async {
    try {
      await _firestore
          .collection('cat')
          .doc(categoryId)
          .collection('items')
          .add(meal.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMeal(String categoryId, MealModel meal) async {
    try {
      await _firestore
          .collection('cat')
          .doc(categoryId)
          .collection('items')
          .doc(meal.id)
          .update(meal.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMeal(String categoryId, String mealId) async {
    try {
      await _firestore
          .collection('cat')
          .doc(categoryId)
          .collection('items')
          .doc(mealId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> acceptOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> startPreparing(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'preparing',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markReadyForPickup(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'readyForPickup',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancelOrderByRestaurant(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'cancelledByRestaurant',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> deleteOrder(String id) async {
    try {
      await _firestore.collection('orders').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDriverById(String driverId) async {
    try {
      final doc = await _firestore
          .collection('DeliveryDrivers')
          .doc(driverId)
          .get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      return null;
    }
  }

  Stream<OrderModel> streamOrder(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((doc) => OrderModel.fromJson(doc.data() ?? {}, doc.id));
  }

  Future<bool> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleUserStatus(String id, bool isActive) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'isActive': isActive,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserStats> getGlobalOrderStats() async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      int totalOrders = snapshot.docs.length;
      int cancelledOrders = 0;
      int completedOrders = 0;
      int pendingOrders = 0;
      double totalSpent = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = (data['status'] ?? '').toString().toLowerCase();

        if (status == 'ملغي' || status == 'cancelled') {
          cancelledOrders++;
        } else if (status == 'مكتمل' ||
            status == 'completed' ||
            status == 'delivered' ||
            status == 'تم التوصيل') {
          completedOrders++;
          final amt = data['totalAmount'] ?? data['total'];
          if (amt != null) {
            totalSpent += (amt is num)
                ? amt.toDouble()
                : double.tryParse(amt.toString()) ?? 0;
          }
        } else {
          pendingOrders++;
        }
      }

      return UserStats(
        totalOrders: totalOrders,
        cancelledOrders: cancelledOrders,
        completedOrders: completedOrders,
        pendingOrders: pendingOrders,
        totalSpent: totalSpent,
      );
    } catch (e) {
      return UserStats();
    }
  }

  Future<UserStats> getUserStats(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      int totalOrders = snapshot.docs.length;
      int cancelledOrders = 0;
      int completedOrders = 0;
      int pendingOrders = 0;
      double totalSpent = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = (data['status'] ?? '').toString().toLowerCase();

        if (status == 'ملغي' || status == 'cancelled') {
          cancelledOrders++;
        } else if (status == 'مكتمل' ||
            status == 'completed' ||
            status == 'delivered' ||
            status == 'تم التوصيل') {
          completedOrders++;

          final amt = data['totalAmount'] ?? data['total'];
          if (amt != null) {
            totalSpent += (amt is num)
                ? amt.toDouble()
                : double.tryParse(amt.toString()) ?? 0;
          }
        } else {
          pendingOrders++;
        }
      }

      return UserStats(
        totalOrders: totalOrders,
        cancelledOrders: cancelledOrders,
        completedOrders: completedOrders,
        pendingOrders: pendingOrders,
        totalSpent: totalSpent,
      );
    } catch (e) {
      return UserStats();
    }
  }

  Stream<List<DriverModel>> streamDrivers() {
    return _firestore
        .collection('DeliveryDrivers')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => DriverModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<bool> addDriver(DriverModel driver) async {
    try {
      await _firestore.collection('DeliveryDrivers').add(driver.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDriver(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('DeliveryDrivers').doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDriver(String id) async {
    try {
      await _firestore.collection('DeliveryDrivers').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<DriverModel> streamDriver(String driverId) {
    return _firestore
        .collection('DeliveryDrivers')
        .doc(driverId)
        .snapshots()
        .map((doc) => DriverModel.fromJson(doc.data() ?? {}, doc.id));
  }

  Future<void> approveDriver(String driverId) async {
    await _firestore.collection('DeliveryDrivers').doc(driverId).update({
      'isApproved': true,
    });
  }

  Stream<List<RestaurantModel>> streamRestaurants() {
    return _firestore
        .collection('restaurants')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => RestaurantModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<bool> addRestaurant(RestaurantModel restaurant) async {
    try {
      await _firestore.collection('restaurants').add(restaurant.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRestaurant(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('restaurants').doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRestaurant(String id) async {
    try {
      await _firestore.collection('restaurants').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<OfferModel>> streamOffers() {
    return _firestore
        .collection('offers')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => OfferModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<bool> addOffer(OfferModel offer) async {
    try {
      await _firestore.collection('offers').add(offer.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOffer(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('offers').doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteOffer(String id) async {
    try {
      final itemsSnap = await _firestore
          .collection('offers')
          .doc(id)
          .collection('items')
          .get();
      for (final doc in itemsSnap.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection('offers').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<MealModel>> streamOfferItems(String offerId) {
    return _firestore
        .collection('offers')
        .doc(offerId)
        .collection('items')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => MealModel.fromJson(doc.data(), doc.id, offerId))
              .toList(),
        );
  }

  Future<bool> addOfferItem(String offerId, MealModel item) async {
    try {
      await _firestore
          .collection('offers')
          .doc(offerId)
          .collection('items')
          .add(item.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOfferItem(String offerId, MealModel item) async {
    try {
      await _firestore
          .collection('offers')
          .doc(offerId)
          .collection('items')
          .doc(item.id)
          .update(item.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteOfferItem(String offerId, String itemId) async {
    try {
      await _firestore
          .collection('offers')
          .doc(offerId)
          .collection('items')
          .doc(itemId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
