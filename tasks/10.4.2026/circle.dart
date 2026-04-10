import 'shape.dart';

class Circle extends Shape {
  double _radius;

  Circle({String color = "black", bool filled = false, double radius = 0})
      : _radius = radius,
        super(color: color, filled: filled);

  @override
  double area() {
    return 3.14 * _radius * _radius;
  }

  @override
  double perimeter() {
    return 2 * 3.14 * _radius;
  }

  @override
  String toString() {
    return "Circle(radius: $_radius, color: $color, filled: $filled)";
  }
}
