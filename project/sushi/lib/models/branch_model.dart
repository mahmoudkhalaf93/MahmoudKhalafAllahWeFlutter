import 'package:cloud_firestore/cloud_firestore.dart';

class BranchModel {
  final GeoPoint? location;
  final String? name;
  final String? nameAr;
  final String? status;
  final String? address;
  final String? addressAr;
  final String? mobile; // Changed from phone to mobile to match DB

  BranchModel({
    this.location,
    this.name,
    this.nameAr,
    this.status,
    this.address,
    this.addressAr,
    this.mobile,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      location: json['location'] as GeoPoint?,
      name: json['name'],
      nameAr: json['nameAr'],
      status: json['status'],
      address: json['address'],
      addressAr: json['addressAr'],
      mobile: json['mobile'], // Corrected field name
    );
  }
}
