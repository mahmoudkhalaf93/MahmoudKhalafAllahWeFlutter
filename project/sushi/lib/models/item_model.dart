class ItemModel {
  final String? name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final double? price;
  final String? image;
  final int? quantity;
  final String? firebaseId;

  ItemModel({
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.price,
    this.image,
    this.quantity,
    this.firebaseId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json, String id) {
    return ItemModel(
      name: json['name'],
      nameAr: json['nameAr'],
      description: json['description'],
      descriptionAr: json['descriptionAr'],
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'],
      quantity: json['quantity'] as int?,
      firebaseId: id,
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
      'quantity': quantity,
    };
  }
}
