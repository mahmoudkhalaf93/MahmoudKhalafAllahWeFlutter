import 'dart:io';

main() {
  double apple = 0,
      banana = 0,
      orange = 0,
      grapes = 0,
      watermelon = 0,
      pineapple = 0;
  double applePrice = 2.5,
      bananaPrice = 1.5,
      orangePrice = 2.0,
      grapesPrice = 3.0,
      watermelonPrice = 5.0,
      pineapplePrice = 4.0;
  String anotherProduct = "yes";
  print("hello customer kindly chose your products by numbers");
  do {
    print("1 - apple price : 2.5\$");
    print("2 - banana price : 1.5\$");
    print("3 - orange price : 2.0\$");
    print("4 - grapes price : 3.0\$");
    print("5 - watermelon price : 5.0\$");
    print("6 - pineapple price : 4.0\$");
    print("enter the number of the product you want to buy : ");
    int? product = int.parse(stdin.readLineSync()!);
    switch (product) {
      case 1:
        print("enter the number of apples you want to buy : ");
        apple += int.parse(stdin.readLineSync()!);
        break;
      case 2:
        print("enter the number of bananas you want to buy : ");
        banana += int.parse(stdin.readLineSync()!);
        break;
      case 3:
        print("enter the number of oranges you want to buy : ");
        orange += int.parse(stdin.readLineSync()!);
        break;
      case 4:
        print("enter the number of grapes you want to buy : ");
        grapes += int.parse(stdin.readLineSync()!);
        break;
      case 5:
        print("enter the number of watermelon you want to buy : ");
        watermelon += int.parse(stdin.readLineSync()!);
        break;
      case 6:
        print("enter the number of pineapple you want to buy : ");
        pineapple += int.parse(stdin.readLineSync()!);
        break;
      default:
        print("invalid product number");
    }
    print("do you want to buy another product ? (yes/no) : ");
    anotherProduct = stdin.readLineSync()!;
  } while (anotherProduct == "yes");

  if (apple > 0) {
    print("you bought $apple apples for ${apple * applePrice}\$");
  }
  if (banana > 0) {
    print("you bought $banana bananas for ${banana * bananaPrice}\$");
  }
  if (orange > 0) {
    print("you bought $orange oranges for ${orange * orangePrice}\$");
  }
  if (grapes > 0) {
    print("you bought $grapes grapes for ${grapes * grapesPrice}\$");
  }
  if (watermelon > 0) {
    print(
      "you bought $watermelon watermelon for ${watermelon * watermelonPrice}\$",
    );
  }

  if (pineapple > 0) {
    print(
      "you bought $pineapple pineapple for ${pineapple * pineapplePrice}\$",
    );
  }

  double totalPrice =
      (apple * applePrice) +
      (banana * bananaPrice) +
      (orange * orangePrice) +
      (grapes * grapesPrice) +
      (watermelon * watermelonPrice) +
      (pineapple * pineapplePrice);
  print("your total price is : $totalPrice\$");
}
