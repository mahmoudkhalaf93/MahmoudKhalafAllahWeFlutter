import 'dart:io';

main() {
  Map<int, double> numbers = {};
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
        //add key and value to the map if key exist show error message and ask user to enter again if key not exist add value to the map and show success message
        print("enter key : ");
        int key = int.parse(stdin.readLineSync()!);
        if (numbers.containsKey(key)) {
          print("****key already exist****");
          break;
        }
        print("enter value : ");
        double value = double.parse(stdin.readLineSync()!);
        numbers[key] = value;
        print("^^^^value added^^^^");
        break;
      case 2:
        //user choose to remove by value or remove by key

        print("1-remove by key");
        print("2-remove by value");
        print("choose remove method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter key to remove : ");
          int key = int.parse(stdin.readLineSync()!);
          if (numbers.containsKey(key)) {
            numbers.remove(key);
            print("^^^^value removed^^^^");
          } else {
            print("****key not found****");
          }
        } else if (method == 2) {
          print("enter value to remove : ");
          double value = double.parse(stdin.readLineSync()!);
          if (numbers.containsValue(value)) {
            int? key;

            numbers.forEach((k, v) {
              if (v == value) {
                key = k;
              }
            });
            numbers.remove(key);

            print("^^^^value removed^^^^");
          } else {
            print("****value not found****");
          }
        } else {
          print("****Invalid method****");
        }

        break;
      case 3:
        //user choose to update by value or update by key

        print("1-update by value");
        print("2-update by key");
        print("choose update method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter value to update : ");
          double oldValue = double.parse(stdin.readLineSync()!);
          if (numbers.containsValue(oldValue)) {
            int? key;
            print("enter new value : ");
            double newValue = double.parse(stdin.readLineSync()!);
            numbers.forEach((k, v) {
              if (v == oldValue) {
                key = k;
              }
            });
            numbers[key!] = newValue;
            print("^^^^value updated^^^^");
          } else {
            print("****Value not found****");
          }
        } else if (method == 2) {
          print("enter key to update : ");
          int key = int.parse(stdin.readLineSync()!);
          if (numbers.containsKey(key)) {
            print("enter new value");
            double newValue = double.parse(stdin.readLineSync()!);
            numbers[key] = newValue;
            print("^^^^value updated at key $key^^^^");
          } else {
            print("****Invalid key****");
          }
        } else {
          print("****Invalid method****");
        }

        break;
      case 4:
        //show values using normal fol loop
        print("values in the map:");
        numbers.forEach((key, value) {
          print("key $key: value: $value");
        });

        break;
      case 5:
        //let user choose between three method only show that is (search by value found or not) or (search by value) or (search by key)
        print("1-search by value found or not");
        print("2-search by value");
        print("3-search by key");
        print("choose search method : ");
        int method = int.parse(stdin.readLineSync()!);
        if (method == 1) {
          print("enter value to search : ");
          double value = double.parse(stdin.readLineSync()!);
          if (numbers.containsValue(value)) {
            print("****value found****");
          } else {
            print("****value not found****");
          }
        } else if (method == 2) {
          print("enter value to search : ");
          double value = double.parse(stdin.readLineSync()!);
          int? key;
          if (numbers.containsValue(value)) {
            numbers.forEach((k, v) {
              if (v == value) {
                key = k;
              }
            });

            print("****value found at key $key****");
          } else {
            print("****value not found****");
          }
        } else if (method == 3) {
          print("enter key to search : ");
          int key = int.parse(stdin.readLineSync()!);
          if (numbers.containsKey(key)) {
            print("****key found with value ${numbers[key]}****");
          } else {
            print("****key not found****");
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
