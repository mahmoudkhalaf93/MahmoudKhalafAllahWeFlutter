import 'package:cloud_firestore/cloud_firestore.dart';

class MealModel {
  final String id;
  final String categoryId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final String image;
  final bool isAvailable;
  final DateTime? createdAt;

  MealModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.nameAr = '',
    this.description = '',
    this.descriptionAr = '',
    required this.price,
    this.image = '',
    this.isAvailable = true,
    this.createdAt,
  });

  factory MealModel.fromJson(
    Map<String, dynamic> json,
    String docId,
    String catId,
  ) {
    return MealModel(
      id: docId,
      categoryId: catId,
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'price': price,
      'image': image,
      'isAvailable': isAvailable,
      'categoryId': categoryId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  MealModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? image,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return MealModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
