class Product {
  String? _name, _description;
  double? _price, _discount;
  int? _quantity;

  Product(this._name, this._price, this._description,
      {double? discount, int? quantity}) {
    _discount = discount ?? 0.0;
    _quantity = quantity ?? 1;
  }
  //get price after discount
  double getPriceAfterDiscount() {
    if (_discount != null || _discount! > 0) {
      return _price! - (_price! * _discount!);
    }
    return _price!;
  }

  //set and get
  String? get name => _name;
  set name(String? value) => _name = value;

  String? get description => _description;
  set description(String? value) => _description = value;

  double? get price => _price;
  set price(double? value) => _price = value;

  double? get discount => _discount;
  set discount(double? value) => _discount = value;

  int? get quantity => _quantity;
  set quantity(int? value) => _quantity = value;
}
