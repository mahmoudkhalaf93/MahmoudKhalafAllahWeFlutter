class Car {
  String? color;
  int? code;
  double? price;
  String? model;

  Car(
      {String color = "black",
      int code = 564621,
      double price = 4652,
      String model = "sedan"}) {
    this.color = color;
    this.code = code;
    this.price = price;
    this.model = model;
  }
}
