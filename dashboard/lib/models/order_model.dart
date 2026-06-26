import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String image;
  final double price;
  final int quantity;
  final String? categoryId;
  final String? mealId;

  OrderItem({
    required this.name,
    this.nameAr = '',
    this.description = '',
    this.descriptionAr = '',
    this.image = '',
    required this.price,
    this.quantity = 1,
    this.categoryId,
    this.mealId,
  });

  double get itemTotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      descriptionAr: json['descriptionAr']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : 1,
      categoryId: json['categoryId']?.toString(),
      mealId: json['mealId']?.toString(),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String? driverId;
  final String status;
  final String payment;

  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double totalAmount;

  final Map<String, dynamic>? deliveryLocation;
  final Map<String, dynamic>? driverLocation;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<OrderItem> items;

  OrderModel({
    required this.id,
    this.userId = '',
    this.driverId,
    required this.status,
    this.payment = '',
    this.subtotal = 0,
    this.discount = 0,
    this.deliveryFee = 0,
    this.totalAmount = 0,
    this.deliveryLocation,
    this.driverLocation,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    final rawItems = json['items'];
    final List<OrderItem> parsedItems = [];
    if (rawItems is List) {
      for (var item in rawItems) {
        if (item is Map<String, dynamic>) {
          parsedItems.add(OrderItem.fromJson(item));
        }
      }
    }

    Map<String, dynamic>? parseLocation(dynamic loc) {
      if (loc == null) return null;
      if (loc is GeoPoint) {
        return {'latitude': loc.latitude, 'longitude': loc.longitude};
      }
      if (loc is Map<String, dynamic>) return loc;
      return null;
    }

    DateTime? parseTimestamp(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return null;
    }

    return OrderModel(
      id: id,
      userId: json['userId']?.toString() ?? '',
      driverId: json['driverId']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      payment: json['payment']?.toString() ?? '',
      subtotal: _toDouble(json['subtotal']),
      discount: _toDouble(json['discount']),
      deliveryFee: _toDouble(json['deliveryFee']),
      totalAmount: _toDouble(json['totalAmount'] ?? json['total']),
      deliveryLocation: parseLocation(json['deliveryLocation']),
      driverLocation: parseLocation(json['driverLocation']),
      createdAt: parseTimestamp(json['createdAt'] ?? json['date']),
      updatedAt: parseTimestamp(json['updatedAt']),
      items: parsedItems,
    );
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'driverId': driverId,
      'status': status,
      'payment': payment,
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
    };
  }

  double get total => totalAmount;
  DateTime? get date => createdAt;
  int get itemCount => items.length;

  bool get isCompleted => status == 'completed';

  String get statusIcon {
    switch (status) {
      case 'completed':
        return '✅';
      case 'driverAssigned':
        return '🚚';
      case 'cancelledByRestaurant':
        return '❌';
      case 'preparing':
        return '👨‍🍳';
      case 'readyForPickup':
        return '📦';
      case 'accepted':
        return '✔️';
      default:
        return '🕐';
    }
  }
}
