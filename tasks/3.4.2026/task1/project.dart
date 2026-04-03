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

  Car car2 = Car();
  car2.color = 'red';
  car2.code = 123;
  car2.price = 10000.0;
  car2.model = 'sedan';

  print('Car color: ${car2.color}');
  print('Car code: ${car2.code}');
  print('Car price: ${car2.price}');
  print('Car model: ${car2.model}');
}
