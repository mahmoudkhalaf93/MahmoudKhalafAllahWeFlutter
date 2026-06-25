import 'product.dart';
import 'visitor.dart';

class Website {
  List<Product> _products = [];
  List<Visitor> _visitors = [];

  //set and get
  List<Product> get products => _products;
  set products(List<Product> value) => _products = value;

  List<Visitor> get visitors => _visitors;
  set visitors(List<Visitor> value) => _visitors = value;

  //add visitor
  void addVisitor(Visitor visitor) {
    _visitors.add(visitor);
  }

  //add product
  void addProduct(Product product) {
    _products.add(product);
  }

  //remove product with name
  void removeProduct(String name) {
    _products.removeWhere((product) => product.name == name);
  }

  //search product by name

  List<Product> searchProductByName(String name) {
    return _products
        .where((product) =>
            product.name != null &&
            product.name!.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  //search product by price range
  List<Product> searchProductByPriceRange(double minPrice, double maxPrice) {
    return _products
        .where((product) =>
            product.price != null &&
            product.price! >= minPrice &&
            product.price! <= maxPrice)
        .toList();
  }
}
