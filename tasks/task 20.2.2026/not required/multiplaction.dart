import 'dart:io';

main() {
  print("select the range of multiplication table from 1 to 12");
  print("select the start number for multiplication table:");
  int? startTable = int.parse(stdin.readLineSync()!);
  print("select the end number for multiplication table:");
  int? endTable = int.parse(stdin.readLineSync()!);
  if (startTable < 1 || endTable > 12 || startTable > endTable) {
    print(
      "Invalid input. Please enter numbers between 1 and 12, and ensure the start number is less than or equal to the end number.",
    );
    return;
  }

  print("select the start number you want to multiply with:");
  int? startMultiplier = int.parse(stdin.readLineSync()!);
  print("select the end number you want to multiply with:");
  int? endMultiplier = int.parse(stdin.readLineSync()!);
  if (startMultiplier < 1 ||
      endMultiplier > 12 ||
      startMultiplier > endMultiplier) {
    print(
      "Invalid input. Please enter numbers between 1 and 12, and ensure the start number is less than or equal to the end number.",
    );
    return;
  }
  for (int i = startTable; i <= endTable; i++) {
    print("Multiplication Table of $i:");
    for (int j = startMultiplier; j <= endMultiplier; j++) {
      print("$i x $j = ${i * j}");
    }
    print(""); // Add an empty line for better readability
  }
}
