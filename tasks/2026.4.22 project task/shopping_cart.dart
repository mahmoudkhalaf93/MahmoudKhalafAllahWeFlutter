class ShoppingCart {
  double _totalPrice = 0.0;
  double _totalpriceWithDiscount = 0.0;
  List _products = [];

  ShoppingCart() {}

  //set and get
  double get totalPrice => _totalPrice;
  set totalPrice(double value) => _totalPrice = value;

  double get totalpriceWithDiscount => _totalpriceWithDiscount;
  set totalpriceWithDiscount(double value) => _totalpriceWithDiscount = value;

  List get products => _products;
  set products(List value) => _products = value;

  //add product
  void addProduct(product) {
    _products.add(product);
    _totalPrice += product.price;
    _totalpriceWithDiscount += product.getPriceAfterDiscount();
  }

  //remove product
  void removeProduct(product) {
    _products.remove(product);
    _totalPrice -= product.price;
    _totalpriceWithDiscount -= product.getPriceAfterDiscount();
  }
}
