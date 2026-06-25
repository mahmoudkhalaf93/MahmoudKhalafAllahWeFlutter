class DriverModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? nationalIdFront;
  final String? nationalIdBack;
  final String? licenseImage;
  final String? vehicleInfo;
  final bool isApproved;
  final bool isOnline;

  DriverModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.nationalIdFront,
    this.nationalIdBack,
    this.licenseImage,
    this.vehicleInfo,
    this.isApproved = false,
    this.isOnline = false,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json, String id) {
    return DriverModel(
      uid: id,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      nationalIdFront: json['nationalIdFront'],
      nationalIdBack: json['nationalIdBack'],
      licenseImage: json['licenseImage'],
      vehicleInfo: json['vehicleInfo'],
      isApproved: json['isApproved'] ?? false,
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'nationalIdFront': nationalIdFront,
      'nationalIdBack': nationalIdBack,
      'licenseImage': licenseImage,
      'vehicleInfo': vehicleInfo,
      'isApproved': isApproved,
      'isOnline': isOnline,
      'role': 'driver',
    };
  }
}
