import 'dart:io';

main() {
  List<double> numbers = [];
  String? continueChoice = 'y';
  while (continueChoice == 'y') {
    print("===============================\nplease choose an operation:");
    print("1-add value");
    print("2-remove value");
    print("3-update values");
    print("4-show values");
    print("5-search  value");
    print("----------\nenter your choice : ");

    //if not int catch error and ask user to enter again
    int choice;
    try {
      choice = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print("***Invalid input, please enter a number***");
      continue;
    }
    switch (choice) {
      case 1:
        print("enter value to add : ");
        double value = double.parse(stdin.readLineSync()!);
        numbers.add(value);
        print("^^^^value added^^^^");
        break;
      case 2:
        //user choose to remove by value or remove by index

        print("1-remove by value");
        print("2-remove by index");
        print("choose removal method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter value to remove : ");
          double value = double.parse(stdin.readLineSync()!);
          //check if value exist in the list
          if (!numbers.contains(value)) {
            print("****value not found****");
            break;
          }
          numbers.remove(value);
          print("^^^^value removed^^^^");
        } else if (method == 2) {
          print("enter index to remove :");
          int index = int.parse(stdin.readLineSync()!);
          if (index >= 0 && index < numbers.length) {
            numbers.removeAt(index);
            print("^^^^value removed at index $index^^^^");
          } else {
            print("****Invalid index****");
          }
        } else {
          print("****Invalid method****");
        }
        break;
      case 3:
        //user choose to update by value or update by index

        print("1-update by value");
        print("2-update by index");
        print("choose update method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter value to update : ");
          double oldValue = double.parse(stdin.readLineSync()!);
          if (numbers.contains(oldValue)) {
            print("enter new value : ");
            double newValue = double.parse(stdin.readLineSync()!);
            int index = numbers.indexOf(oldValue);
            numbers[index] = newValue;
            print("^^^^value updated^^^^");
          } else {
            print("****Value not found****");
          }
        } else if (method == 2) {
          print("enter index to update : ");
          int index = int.parse(stdin.readLineSync()!);
          if (index >= 0 && index < numbers.length) {
            print("enter new value");
            double newValue = double.parse(stdin.readLineSync()!);
            numbers[index] = newValue;
            print("^^^^value updated at index $index^^^^");
          } else {
            print("****Invalid index****");
          }
        } else {
          print("****Invalid method****");
        }

        break;
      case 4:
        //show values using normal fol loop
        print("values in the list:");
        for (int i = 0; i < numbers.length; i++) {
          print("index $i: ${numbers[i]}");
        }
        break;
      case 5:
        //let user choose between two method only show that is value found or not or get index

        print("1-get index of value");
        print("2-found or not found");
        print("choose search method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter value to search : ");
          double value = double.parse(stdin.readLineSync()!);
          int index = numbers.indexOf(value);
          if (index != -1) {
            print("value found at index $index");
          } else {
            print("****value not found****");
          }
        } else if (method == 2) {
          print("enter value to search : ");
          double value = double.parse(stdin.readLineSync()!);
          if (numbers.contains(value)) {
            print("^^^^value found^^^^");
          } else {
            print("****value not found****");
          }
        } else {
          print("****Invalid method****");
        }

        break;
      default:
        print("****Invalid choice****");
    }
    //ask user if they want to continue or exit
    print("do you want to continue? (y/n) : ");
    continueChoice = stdin.readLineSync()!.toLowerCase();
  }
}
