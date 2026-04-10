import 'shape.dart';

class Rectabgle extends Shape {
  double _width;
  double _length;

  Rectabgle(
      {String color = "green",
      bool filled = false,
      double width = 0,
      double length = 0})
      : _width = width,
        _length = length,
        super(color: color, filled: filled);

  @override
  double area() {
    return _width * _length;
  }

  @override
  double perimeter() {
    return 2 * (_width + _length);
  }

  @override
  String toString() {
    return "Rectangle(width: $_width, length: $_length, color: $color, filled: $filled)";
  }
}
