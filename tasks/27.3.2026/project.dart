import 'dart:io';

main() {
  double a = 10, b = 5, c = 3, d = 2;
  print("the numbers are: a = $a, b = $b, c = $c, d = $d");
  print("result case 0 parameters: ${result()} ");
  print("result case 1 parameter summation b($b): ${result(b: b)} ");
  print(
      "result case 2 parameters division c($c),b($b): ${result(c: c, b: b)} ");
  print(
      "result case 3 parameters multiplication d($d),b($b),c($c): ${result(d: d, b: b, c: c)} ");
  print(
      "result case 4 parameters addition a($a),b($b),c($c),d($d): ${result(a: a, b: b, c: c, d: d)} ");
}

double result({double a = -1, double b = -1, double c = -1, double d = -1}) {
  List<double> numbers = [a, b, c, d];
  numbers.removeWhere((element) => element == -1);
  int n = numbers.length;
  switch (n) {
    case 1:
      return sum(numbers[0]);
    case 2:
      return divide(numbers[0], numbers[1]);
    case 3:
      return numbers[0] * numbers[1] * numbers[2];
    case 4:
      return numbers[0] + numbers[1] + numbers[2] + numbers[3];
    default:
      return 1;
  }
}

double sum(double n) {
  double sum = 0;
  for (double i = 0; i <= n; i++) {
    sum += i;
  }
  return sum;
}

//check bigger number and divide it by smaller number
double divide(double a, double b) {
  if (a > b) {
    return a / b;
  } else {
    return b / a;
  }
}
