import 'product.dart';
import 'visitor.dart';
import 'website.dart';

main() {
  Website TechZone = Website();

  Product laptop = Product("Laptop", 15000, "A powerful laptop",
      discount: 0.1); // 10% discount
  Product headphones = Product("Headphones", 800, "Noise-cancelling headphones",
      discount: 0.2); // 20% discount
  Product charger = Product("Charger", 200, "Fast charging cable",
      discount: 0.05); // 5% discount
  TechZone.addProduct(laptop);
  TechZone.addProduct(headphones);
  TechZone.addProduct(charger);

  Visitor visitor1 = Visitor("Ahmed", "Ahmed@email.com");
  Visitor visitor2 = Visitor("Sara", "sara@email.com");
  TechZone.addVisitor(visitor1);
  TechZone.addVisitor(visitor2);

  visitor1.shoppingCart.addProduct(laptop);
  visitor2.shoppingCart.addProduct(charger);

  //print total price for visitor1 before and after discount
  print(
      "Total price for ${visitor1.name} before discount: ${visitor1.shoppingCart.totalPrice}");
  print(
      "Total price for ${visitor1.name} after discount: ${visitor1.shoppingCart.totalpriceWithDiscount}");

  //search for products named headphones and print the index
  List<Product> searchResults = TechZone.searchProductByName("Headphones");
  if (searchResults.isNotEmpty) {
    int index = TechZone.products.indexOf(searchResults[0]);
    print("Product 'Headphones' found at index: $index");
  } else {
    print("Product 'Headphones' not found.");
  }
  //remove laptop from the website
  TechZone.removeProduct("Laptop");
  //print the updated list of products
  print("Updated list of products:");
  for (var product in TechZone.products) {
    print("- ${product.name}");
  }
}
