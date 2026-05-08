import 'dart:io';

import 'course.dart';
import 'coursera.dart';
import 'lecture.dart';
import 'sheet.dart';
import 'teacher.dart';

void main() {
  Coursera coursera = Coursera();
  Teacher? teacher;
  print("Welcome to Coursera!");

  //press 1 to register or 2 to login
  print("Press 1 to register or 2 to login");
  int choice = int.parse(stdin.readLineSync()!);
  if (choice == 1) {
    //register
    print("Enter your name:");
    String name = stdin.readLineSync()!;
    print("Enter your email:");
    String email = stdin.readLineSync()!;
    print("Enter your password:");
    String password = stdin.readLineSync()!;
    Teacher teacherReg = Teacher(name, email, password);
    teacher = coursera.register(teacherReg);
    print("Registration successful");
  } else if (choice == 2) {
    //login
    print("Enter your name:");
    String name = stdin.readLineSync()!;
    print("Enter your password:");
    String password = stdin.readLineSync()!;
    teacher = coursera.login(name, password);
  } else {
    print("Invalid choice");
  }

  if (teacher != null) {
    print("Welcome to your dashboard!");
    print("please add new course");
    print("Enter course name:");
    String courseName = stdin.readLineSync()!;
    print("Enter course description:");
    String courseDescription = stdin.readLineSync()!;
    Course course = Course(courseName, courseDescription);
    coursera.teachers
        .where((element) => element.name == teacher!.name)
        .first
        .addCourse(course);
    print("Course added successfully");
    print("do you want to add new course? (y/n)");
    String addCourseChoice = stdin.readLineSync()!;
    while (addCourseChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
      print("Enter course description:");
      String courseDescription = stdin.readLineSync()!;
      Course course = Course(courseName, courseDescription);
      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .addCourse(course);
      print("Course added successfully");
      print("do you want to add new course? (y/n)");
      addCourseChoice = stdin.readLineSync()!;
    }
    print("do you add any course by accident do you want to delete it? (y/n)");
    String deleteCourseChoice = stdin.readLineSync()!;
    while (deleteCourseChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
//check if course exists
      if (!coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .any((element) => element.courseName == courseName)) {
        print("Course not found");
        continue;
      }

      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .deleteCourse(courseName);
      print("Course deleted successfully");

      //teacher.showCourses();
      print(
          "do you add any course by accident do you want to delete it? (y/n)");
      deleteCourseChoice = stdin.readLineSync()!;
    }
    //add lectures to course
    print("do you want to add lectures to your course? (y/n)");
    String addLectureChoice = stdin.readLineSync()!;
    while (addLectureChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
      if (!coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .any((element) => element.courseName == courseName)) {
        print("Course not found");
        continue;
      }
      print("Enter lecture name:");
      String lectureName = stdin.readLineSync()!;
      print("Enter lecture description:");
      String lectureDescription = stdin.readLineSync()!;
      print("Enter lecture file name:");
      String lectureFileName = stdin.readLineSync()!;
      Lecture lecture =
          Lecture(lectureName, lectureDescription, lectureFileName);
      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .where((element) => element.courseName == courseName)
          .first
          .addLecture(lecture);
      print("Lecture added successfully");
      print("do you want to add lectures to your course? (y/n)");
      addLectureChoice = stdin.readLineSync()!;
    }
    //delete lectures from course
    print("do you want to delete lectures from your course? (y/n)");
    String deleteLectureChoice = stdin.readLineSync()!;
    while (deleteLectureChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
      print("Enter lecture name:");
      String lectureName = stdin.readLineSync()!;
      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .where((element) => element.courseName == courseName)
          .first
          .deleteLecture(lectureName);
      print("Lecture deleted successfully");
      print("do you want to delete lectures from your course? (y/n)");
      deleteLectureChoice = stdin.readLineSync()!;
    }
    //add sheets to course
    print("do you want to add sheets to your course? (y/n)");
    String addSheetChoice = stdin.readLineSync()!;
    while (addSheetChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
      print("Enter sheet number:");
      double sheetNumber = double.parse(stdin.readLineSync()!);
      print("Enter sheet description:");
      String sheetDescription = stdin.readLineSync()!;
      print("Enter sheet file name:");
      String sheetFileName = stdin.readLineSync()!;
      Sheet sheet = Sheet(sheetNumber, sheetDescription, sheetFileName);
      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .where((element) => element.courseName == courseName)
          .first
          .addSheet(sheet);
      print("Sheet added successfully");
      print("do you want to add sheets to your course? (y/n)");
      addSheetChoice = stdin.readLineSync()!;
    }
    //delete sheets from course
    print("do you want to delete sheets from your course? (y/n)");
    String deleteSheetChoice = stdin.readLineSync()!;
    while (deleteSheetChoice.toLowerCase() == 'y') {
      print("Enter course name:");
      String courseName = stdin.readLineSync()!;
      print("Enter sheet number:");
      double sheetNumber = double.parse(stdin.readLineSync()!);
      coursera.teachers
          .where((element) => element.name == teacher!.name)
          .first
          .courses
          .where((element) => element.courseName == courseName)
          .first
          .deleteSheet(sheetNumber);
      print("Sheet deleted successfully");
      print("do you want to delete sheets from your course? (y/n)");
      deleteSheetChoice = stdin.readLineSync()!;
    }
  }
}
