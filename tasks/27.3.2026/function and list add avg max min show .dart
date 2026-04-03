import 'dart:io';

main() {
  List<int> list = [];
  print("how many items do you want in the list?");
  int n = int.parse(stdin.readLineSync()!);
  list = getList(n);
  showList(list);
  int sum = sumList(list);
  print("the sum of the items in the list is: $sum");
  double average = averageList(list);
  print("the average of the items in the list is: $average");
  Map<String, int> maxMin = MaxMinList(list);
  print("the maximum item in the list is: ${maxMin["max"]}");
  print("the minimum item in the list is: ${maxMin["min"]}");
}

List<int> getList(int n) {
  List<int> list = [];
  for (int i = 0; i < n; i++) {
    print("enter item ${i + 1}:");
    int item = int.parse(stdin.readLineSync()!);
    list.add(item);
  }
  return list;
}

void showList(List<int> list) {
  stdout.write("the items in the list are: {");
  for (int item in list) {
    stdout.write("$item");
    if (item != list.last) {
      stdout.write(" , ");
    }
  }
  print("}"); // Print a newline after the list
}

int sumList(List<int> list) {
  int sum = 0;
  for (int item in list) {
    sum += item;
  }
  return sum;
}

double averageList(List<int> list) {
  int sum = sumList(list);
  return sum / list.length;
}

Map<String, int> MaxMinList(List<int> list) {
  int max = list[0];
  int min = list[0];
  for (int item in list) {
    if (item > max) {
      max = item;
    }
    if (item < min) {
      min = item;
    }
  }
  return {"max": max, "min": min};
}
