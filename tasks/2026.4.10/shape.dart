abstract class Shape {
  String _color;
  bool _filled;

  Shape({String color = "white", bool filled = false})
      : _color = color,
        _filled = filled;

//set and get attributes
  String get color => _color;
  set color(String color) => _color = color;

  bool get filled => _filled;
  set filled(bool filled) => _filled = filled;

  //abstract methods

  double area();
  double perimeter();
  String toString();
}
