import 'branch_model.dart';

class RestaurantModel {
  final String? name;
  final String? nameAr;
  final String? phone;
  final List<BranchModel>? branches;

  RestaurantModel({
    this.name,
    this.nameAr,
    this.phone,
    this.branches,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    var branchList = json['branches'] as List?;
    List<BranchModel>? branches = branchList?.map((b) => BranchModel.fromJson(b)).toList();

    return RestaurantModel(
      name: json['name'],
      nameAr: json['nameAr'],
      phone: json['phone'],
      branches: branches,
    );
  }
}
