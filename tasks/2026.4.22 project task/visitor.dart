import 'shopping_cart.dart';

class Visitor {
  String _name, _email;
  ShoppingCart _shoppingCart;
  //constructor
  Visitor(this._name, this._email, {ShoppingCart? shoppingCart})
      : _shoppingCart = shoppingCart ?? ShoppingCart();
  //set and get
  String get name => _name;
  set name(String name) => _name = name;
  String get email => _email;
  set email(String email) => _email = email;
  ShoppingCart get shoppingCart => _shoppingCart;
  set shoppingCart(ShoppingCart shoppingCart) => _shoppingCart = shoppingCart;
}
