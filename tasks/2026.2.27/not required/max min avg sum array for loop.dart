import 'dart:io';

main() {
  print("how many numbers do you want to enter?");
  int n = int.parse(stdin.readLineSync()!);
  List<double> numbers = [];
  double sum = 0;

  for (int i = 0; i < n; i++) {
    print("Enter number ${i + 1}:");
    double num = double.parse(stdin.readLineSync()!);
    numbers.add(num);
  }

  for (int i = 0; i < numbers.length; i++) {
    print("number ${i + 1}: ${numbers[i]}");
    sum += numbers[i];
  }
  print("Sum of numbers: $sum");

  print("the average is: ${sum / n}");

  //get the maximum and minimum number using for normal loop and if statement

  double max = numbers[0];
  double min = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    double num = numbers[i];
    if (num > max) {
      max = num;
    }
    if (num < min) {
      min = num;
    }
  }
  print("the maximum number is: $max");
  print("the minimum number is: $min");
}
