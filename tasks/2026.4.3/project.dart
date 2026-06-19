import 'dart:io';
import 'car.dart';

main() {
  ///how many cars do you want to add it to the list
  print("How many cars do you want to add it to the list");
  int numberOfCars = int.parse(stdin.readLineSync()!);
  List<Car> cars = [];
  for (int i = 0; i < numberOfCars; i++) {
    print("Enter data of car ${i + 1}:");
    Car car = Car();
    car.fillData();
    cars.add(car);
  }
  //print all cars in the list in good format
  for (int i = 0; i < cars.length; i++) {
    print("Car ${i + 1}:${cars[i].getModel()} - ");
    cars[i].printData();
    print(" -----------------------------");
  }
  //print total price of all cars in the list
  double totalPrice = 0;
  for (int i = 0; i < cars.length; i++) {
    totalPrice += cars[i].getPrice();
  }
  print("Total price of all cars: $totalPrice");
  //make discount of 15% on all cars in the list and print the new price and old of each car and in the end print the total price of all cars after discount and before discount
  double totalPriceAfterDiscount = 0;
  for (int i = 0; i < cars.length; i++) {
    double oldPrice = cars[i].getPrice();
    double newPrice = oldPrice - (oldPrice * 0.15);
    totalPriceAfterDiscount += newPrice;
    print("Car ${i + 1}:${cars[i].getModel()} - ");

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
    if (cars[i].getPrice() > mostExpensiveCar.getPrice()) {
      mostExpensiveCar = cars[i];
    }
    if (cars[i].getPrice() < cheapestCar.getPrice()) {
      cheapestCar = cars[i];
    }
  }
  print("==================================");
  print("Most expensive car:");
  mostExpensiveCar.printData();
  print("==================================");
  print("Cheapest car:");
  cheapestCar.printData();
}
