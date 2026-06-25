main() {
  double x = 2, y = 3, z = 5;

  double re1 =
      (factorial(x) * power(x, y) + sum(z)) / (power(z, y) * factorial(y));
  print("Result1: $re1");
  double re2 = (power(x, y) * power(x, z)) /
      (sum(x) * sum(y) + factorial(z) * factorial(y));
  print("Result2: $re2");
}

double factorial(double n) {
  if (n == 0) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}

double sum(double n) {
  double sum = 0;
  for (double i = 0; i <= n; i++) {
    sum += i;
  }
  return sum;
}

double power(double base, double exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
