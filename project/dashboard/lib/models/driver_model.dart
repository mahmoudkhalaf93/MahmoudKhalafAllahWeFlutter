class DriverModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isApproved;
  final bool isOnline;
  final String profileImage;
  final String licenseImage;
  final String nationalIdFront;
  final String nationalIdBack;
  final String? vehicleInfo;

  DriverModel({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.role = '',
    this.isApproved = false,
    this.isOnline = false,
    this.profileImage = '',
    this.licenseImage = '',
    this.nationalIdFront = '',
    this.nationalIdBack = '',
    this.vehicleInfo,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json, String id) {
    return DriverModel(
      id: id,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      isApproved: json['isApproved'] == true,
      isOnline: json['isOnline'] == true,
      profileImage: (json['profileImage'] ?? '').toString(),
      licenseImage: (json['licenseImage'] ?? '').toString(),
      nationalIdFront: (json['nationalIdFront'] ?? '').toString(),
      nationalIdBack: (json['nationalIdBack'] ?? '').toString(),
      vehicleInfo: json['vehicleInfo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isApproved': isApproved,
      'isOnline': isOnline,
      'profileImage': profileImage,
      'licenseImage': licenseImage,
      'nationalIdFront': nationalIdFront,
      'nationalIdBack': nationalIdBack,
      'vehicleInfo': vehicleInfo,
    };
  }

  String get image => profileImage;
  String get nationalId => nationalIdFront;
  bool get isActive => isApproved;
}
