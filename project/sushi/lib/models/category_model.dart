class CategoryModel {
  final String? name;
  final String? description;
  final String? nameAr;
  final String? descriptionAr;
  final String? image;
  final String? firebaseId;

  CategoryModel({
    this.name,
    this.description,
    this.nameAr,
    this.descriptionAr,
    this.image,
    this.firebaseId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoryModel(
      name: json['name'],
      description: json['description'],
      nameAr: json['nameAr'],
      descriptionAr: json['descriptionAR'],
      image: json['image'],
      firebaseId: id,
    );
  }
}
