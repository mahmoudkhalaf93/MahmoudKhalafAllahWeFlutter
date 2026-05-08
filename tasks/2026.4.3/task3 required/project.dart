import 'dart:io';

import 'car.dart';

main() {
  ///how many cars do you want to add it to the list
  print("How many cars do you want to add it to the list");
  int numberOfCars = int.parse(stdin.readLineSync()!);
  List<Car> cars = [];
  for (int i = 0; i < numberOfCars; i++) {
    print("Enter the color of the car no.${i + 1}");
    String color = stdin.readLineSync()!;
    print("Enter the code of the car no.${i + 1}");
    int code = int.parse(stdin.readLineSync()!);
    print("Enter the price of the car no.${i + 1}");
    double price = double.parse(stdin.readLineSync()!);
    print("Enter the model of the car no.${i + 1}");
    String model = stdin.readLineSync()!;
    Car car = Car(color: color, code: code, price: price, model: model);
    cars.add(car);
  }
  //print all cars in the list in good format
  for (int i = 0; i < cars.length; i++) {
    print("Car ${i + 1}:${cars[i].model} - ");
    print("Color: ${cars[i].color}");
    print("Code: ${cars[i].code}");
    print("Price: ${cars[i].price}");
    print("Model: ${cars[i].model}");
  }
  //print total price of all cars in the list
  double totalPrice = 0;
  for (int i = 0; i < cars.length; i++) {
    totalPrice += cars[i].price!;
  }
  print("Total price of all cars: $totalPrice");
  //make discount of 15% on all cars in the list and print the new price and old of each car and in the end print the total price of all cars after discount and before discount
  double totalPriceAfterDiscount = 0;
  for (int i = 0; i < cars.length; i++) {
    double oldPrice = cars[i].price!;
    double newPrice = oldPrice - (oldPrice * 0.15);
    totalPriceAfterDiscount += newPrice;
    print("Car ${i + 1}:${cars[i].model} - ");

    print("Old Price: $oldPrice");
    print("New Price: $newPrice");
    print(" -----------------------------");
  }
  print("==================================");
  print("Total price of all cars after discount: $totalPriceAfterDiscount");
  print("-----------------------------------");
  print("Total price of all cars before discount: $totalPrice");
  print("==================================");
  // print the most expensive car in the list and the cheapest car in the list
  Car mostExpensiveCar = cars[0];
  Car cheapestCar = cars[0];
  for (int i = 1; i < cars.length; i++) {
    if (cars[i].price! > mostExpensiveCar.price!) {
      mostExpensiveCar = cars[i];
    }
    if (cars[i].price! < cheapestCar.price!) {
      cheapestCar = cars[i];
    }
  }
  print("==================================");
  print("Most expensive car:");
  print("Color: ${mostExpensiveCar.color}");
  print("Code: ${mostExpensiveCar.code}");
  print("Price: ${mostExpensiveCar.price}");
  print("Model: ${mostExpensiveCar.model}");
  print("==================================");
  print("Cheapest car:");
  print("Color: ${cheapestCar.color}");
  print("Code: ${cheapestCar.code}");
  print("Price: ${cheapestCar.price}");
  print("Model: ${cheapestCar.model}");
}
