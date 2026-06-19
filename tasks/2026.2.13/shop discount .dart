import 'dart:io';

main() {
  double priceA = 45, priceB = 90, PriceC = 70, priceD = 150;

  print('enter number  of pro A : ');
  double A = double.parse(stdin.readLineSync()!);

  print('enter number  of pro B : ');
  double B = double.parse(stdin.readLineSync()!);

  print('enter number  of pro C : ');
  double C = double.parse(stdin.readLineSync()!);

  print('enter number  of pro D : ');
  double D = double.parse(stdin.readLineSync()!);

  print("\nbilling");

  print(printPriceOfItem(15, priceA, A, "A"));
  print(printPriceOfItem(7.5, priceB, B, "B"));
  print(printPriceOfItem(10, PriceC, C, "C"));
  print(printPriceOfItem(15, priceD, D, "D"));
  //print the total price

  print(
    "\ntotal price of all items is : ${(priceA * A) + (priceB * B) + (PriceC * C) + (priceD * D)}",
  );
}

String printPriceOfItem(double dis, double price, double Q, String name) {
  if (Q >= 5)
    return "price of $name ${(price * Q)} after discount ${(price - (price * dis / 100)) * Q}";
  else
    return "price of $name ${(price * Q)}";
}
