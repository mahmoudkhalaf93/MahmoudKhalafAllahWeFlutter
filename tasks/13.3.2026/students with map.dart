import 'dart:io';

main() {
  List<Map> students = [];
  //how many students do you want to add?
  print("How many students do you want to add?");
  int n = int.parse(stdin.readLineSync()!);
  // loop to add students id and name and  subject degree as map and ask how many subjects do you want to add for each student min subject is 3 and max is 12 if the user enter less than 3 or more than 12 let the user know that it's invalid and ask them to enter a valid number of subjects until they enter a valid number then add the subjects to the student map as a list of maps with subject name as keys and degree as values double
  // then add the subject name and degree as map to the student map
  for (int i = 0; i < n; i++) {
    Map student = {};
    //id only numbers if not try again
    int id;
    do {
      print("Enter student id (numbers only):");
      id = int.parse(stdin.readLineSync()!);
      if (id is! int) {
        print("Invalid id. Please enter a valid id.");
      }
    } while (id is! int);
    student['id'] = id;
    print("Enter student name:");
    student['name'] = stdin.readLineSync()!;
    List<Map> subjects = [];
    int m;
    do {
      print(
          "How many subjects do you want to add for this student? (min 3, max 12)");
      m = int.parse(stdin.readLineSync()!);
      if (m < 3 || m > 12) {
        print("Invalid number of subjects. Please enter a valid number.");
      }
    } while (m < 3 || m > 12);
    for (int j = 0; j < m; j++) {
      Map subject = {};
      print("Enter subject name:");
      subject['name'] = stdin.readLineSync()!;
      //check if the degree is between 0 and 100 if not let the user know that it's invalid and ask them to enter a valid degree until they enter a valid degree
      double degree;
      do {
        print("Enter subject degree (0-100):");
        degree = double.parse(stdin.readLineSync()!);
        if (degree < 0 || degree > 100) {
          print("Invalid degree. Please enter a valid degree.");
        }
      } while (degree < 0 || degree > 100);
      subject['degree'] = degree;
      subjects.add(subject);
    }
    student['subjects'] = subjects;
    students.add(student);
  }

  //print all students with their subjects and degrees and total and percentage and grade Excellent for percentage >= 85, very good for percentage >= 75 and < 85, good for percentage >= 65 and < 75, pass for percentage >= 50 and < 65, failure for percentage < 50 and print student id and name and subjects with degrees and total and percentage and grade for each student and max percentage and min percentage for all students
  double maxPercentage = 0;
  double minPercentage = 100;
  Map topStudent = {};
  Map lowStudent = {};
  for (var student in students) {
    print("********************************");
    print("Student ID: ${student['id']}");
    print("Student Name: ${student['name']}");
    List<Map> subjects = student['subjects'];
    double total = 0;
    stdout.write("Subjects: ");
    for (var subject in subjects) {
      stdout.write("( ${subject['name']}: ${subject['degree']})");
      total += subject['degree'];
    }
    double percentage = total * 100 / (subjects.length * 100);
    String grade;
    if (percentage >= 85) {
      grade = "Excellent";
    } else if (percentage >= 75) {
      grade = "Very Good";
    } else if (percentage >= 65) {
      grade = "Good";
    } else if (percentage >= 50) {
      grade = "Pass";
    } else {
      grade = "Failure";
    }
    print("\nTotal: $total");
    print("Percentage: $percentage");
    print("Grade: $grade");
    if (percentage > maxPercentage) {
      maxPercentage = percentage;
      topStudent = student;
    }
    if (percentage < minPercentage) {
      minPercentage = percentage;
      lowStudent = student;
    }
  }
  print("===================================================");
  print("Top Student: ${topStudent['name']} with percentage: $maxPercentage");
  print("Low Student: ${lowStudent['name']} with percentage: $minPercentage");
}
