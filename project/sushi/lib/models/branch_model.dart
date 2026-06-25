import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final GeoPoint? location;
  final String? name;
  final String? nameAr;
  final String? status;

  BranchModel({
    this.location,
    this.name,
    this.nameAr,
    this.status,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      location: json['location'] as GeoPoint?,
      name: json['name'],
      nameAr: json['nameAr'],
      status: json['status'],
    );
  }
}
