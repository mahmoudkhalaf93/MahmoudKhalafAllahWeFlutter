class UserModel {
  final String? email;
  final String? image;
  final String? name;
  final String? phone;

  UserModel({
    this.email,
    this.image,
    this.name,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      image: json['image'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image': image,
      'name': name,
      'phone': phone,
    };
  }
}
