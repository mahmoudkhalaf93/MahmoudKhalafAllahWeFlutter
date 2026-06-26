import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String phone;
  final String address;
  final bool isActive;
  final DateTime? createdAt;
  final List<RestaurantBranch> branches;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.address,
    this.isActive = true,
    this.createdAt,
    this.branches = const [],
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json, String id) {
    return RestaurantModel(
      id: id,
      name: (json['name'] != null && json['name'].toString().isNotEmpty)
          ? json['name']
          : id,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map(
                (e) => RestaurantBranch.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'phone': phone,
      'address': address,
      'isActive': isActive,
      'branches': branches.map((b) => b.toJson()).toList(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? phone,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    List<RestaurantBranch>? branches,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      branches: branches ?? this.branches,
    );
  }
}

class RestaurantBranch {
  final String name;
  final String nameAr;
  final String status;
  final GeoPoint? location;

  RestaurantBranch({
    required this.name,
    required this.nameAr,
    required this.status,
    this.location,
  });

  factory RestaurantBranch.fromJson(Map<String, dynamic> json) {
    return RestaurantBranch(
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      status: json['status'] ?? 'open',
      location: json['location'] is GeoPoint
          ? json['location'] as GeoPoint
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameAr': nameAr,
      'status': status,
      if (location != null) 'location': location,
    };
  }
}
