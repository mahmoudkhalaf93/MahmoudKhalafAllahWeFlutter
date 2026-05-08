import 'dart:io';

import 'car.dart';

main() {
  Car car1 = Car();
  // let user input for car1 properties
  stdout.write('Enter car color: ');
  car1.color = stdin.readLineSync();
  stdout.write('Enter car code: ');
  car1.code = int.parse(stdin.readLineSync()!);
  stdout.write('Enter car price: ');
  car1.price = double.parse(stdin.readLineSync()!);
  stdout.write('Enter car model: ');
  car1.model = stdin.readLineSync();
// print car1 properties
  print('Car color: ${car1.color}');
  print('Car code: ${car1.code}');
  print('Car price: ${car1.price}');
  print('Car model: ${car1.model}');

  Car car2 = Car(color: 'red', code: 123456, price: 7890);

  print('Car color: ${car2.color}');
  print('Car code: ${car2.code}');
  print('Car price: ${car2.price}');
  print('Car model: ${car2.model}');
}
