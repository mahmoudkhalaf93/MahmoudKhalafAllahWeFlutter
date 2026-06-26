import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime? createdAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.createdAt,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? 'غير متوفر',
      email: json['email'] ?? 'غير متوفر',
      phone: json['phone'] ?? 'غير متوفر',
      createdAt: _parseDate(
        json['createdAt'] ??
            json['created_at'] ??
            json['date'] ??
            json['timestamp'],
      ),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'isActive': isActive,
    };
  }

  static DateTime? _parseDate(dynamic rawDate) {
    if (rawDate == null) return null;
    if (rawDate is Timestamp) return rawDate.toDate();
    if (rawDate is String) return DateTime.tryParse(rawDate);
    if (rawDate is int) return DateTime.fromMillisecondsSinceEpoch(rawDate);
    return null;
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
