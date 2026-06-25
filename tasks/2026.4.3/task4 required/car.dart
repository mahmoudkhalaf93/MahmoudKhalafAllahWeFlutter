import 'dart:io';

class Car {
  String? _color;
  int? _code;
  double? _price;
  String? _model;

  Car(
      {String color = "black",
      int code = 564621,
      double price = 4652,
      String model = "sedan"}) {
    this._color = color;
    this._code = code;
    this._price = price;
    this._model = model;
  }
  //setters
  set color(String color) {
    this._color = color;
  }

  set code(int code) {
    this._code = code;
  }

  set price(double price) {
    this._price = price;
  }

  set model(String model) {
    this._model = model;
  }

  //getters
  String getColor() {
    return this._color!;
  }

  int getCode() {
    return this._code!;
  }

  double getPrice() {
    return this._price!;
  }

  String getModel() {
    return this._model!;
  }

//fill data by user
  void fillData() {
    print("Enter color:");
    String color = stdin.readLineSync()!;
    print("Enter code:");
    int code = int.parse(stdin.readLineSync()!);
    print("Enter price:");
    double price = double.parse(stdin.readLineSync()!);
    print("Enter model:");
    String model = stdin.readLineSync()!;
    this._color = color;
    this._code = code;
    this._price = price;
    this._model = model;
  }

  void printData() {
    print("Color: ${this._color}");
    print("Code: ${this._code}");
    print("Price: ${this._price}");
    print("Model: ${this._model}");
  }
}
