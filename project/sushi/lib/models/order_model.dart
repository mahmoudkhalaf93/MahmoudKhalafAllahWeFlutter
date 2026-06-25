import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_model.dart';

enum OrderStatus {
  // Restaurant Phase
  pending,
  accepted,
  preparing,
  readyForPickup,
  
  // Driver Phase
  driverAssigned,
  arrivedAtRestaurant,
  outForDelivery,
  arrivedAtCustomer,
  
  // Final States
  delivered,
  cancelledByCustomer,
  cancelledByRestaurant,
  failedDelivery
}

class OrderModel {
  final String id;
  final String userId;
  final String? driverId;
  final List<ItemModel> items;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GeoPoint? deliveryLocation;
  final GeoPoint? driverLocation;

  OrderModel({
    required this.id,
    required this.userId,
    this.driverId,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryLocation,
    this.driverLocation,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      driverId: json['driverId'],
      items: (json['items'] as List?)?.map((i) => ItemModel.fromJson(i, '')).toList() ?? [],
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'pending'), 
        orElse: () => OrderStatus.pending
      ),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : DateTime.now(),
      deliveryLocation: json['deliveryLocation'],
      driverLocation: json['driverLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'driverId': driverId,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status.name,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'deliveryLocation': deliveryLocation,
      'driverLocation': driverLocation,
    };
  }

  bool get isExpired {
    if (status == OrderStatus.delivered || status.index > OrderStatus.delivered.index) return false;
    final diff = DateTime.now().difference(createdAt);
    return diff.inMinutes > 150;
  }
}
