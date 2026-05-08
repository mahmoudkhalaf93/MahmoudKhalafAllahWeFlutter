import 'circle.dart';
import 'rectangle.dart';

void main(List<String> args) {
//case study: create a circle and a rectangle, then print their details, area, and perimeter.
  Circle circle = Circle(radius: 5, color: "red", filled: true);
  print("case 1 fill all attributes of circle :");
  print(circle);
  print("Area of circle: ${circle.area()}");
  print("Perimeter of circle: ${circle.perimeter()}");

  print(
      "```````````````change the color and filled status of the circle and print the updated details.```````````````");
  //case study: change the color and filled status of the circle and print the updated details.
  circle.color = "yellow";
  circle.filled = false;
  print("Updated circle: $circle");
//case study: create a new circle with default attributes and print its details, area, and perimeter.
  Circle defaultCircle = Circle();
  print("===========");
  print("case 2 create a new circle with default attributes :");
  print(defaultCircle);
  print("Area of circle: ${defaultCircle.area()}");
  print("Perimeter of circle: ${defaultCircle.perimeter()}");

  print("=====================================");
  //case study: create a rectangle and print its details, area, and perimeter.
  Rectabgle rectangle =
      Rectabgle(width: 4, length: 6, color: "blue", filled: false);
  print(rectangle);
  print("Area of rectangle: ${rectangle.area()}");
  print("Perimeter of rectangle: ${rectangle.perimeter()}");
}
