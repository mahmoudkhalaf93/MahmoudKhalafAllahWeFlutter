import 'course.dart';

class Teacher {
  String _name;
  String _email;
  String _password;
  List<Course> _courses = [];

  Teacher(this._name, this._email, this._password);

  //setters
  set name(String name) => this._name = name;
  set email(String email) => this._email = email;
  set password(String password) => this._password = password;

  set courses(List<Course> courses) => this._courses = courses;

  //getters
  String get name => _name;
  String get email => _email;
  String get password => _password;
  List<Course> get courses => _courses;
  //add course to teacher
  void addCourse(Course course) {
    _courses.add(course);
  }

  //delete course from teacher
  void deleteCourse(String course_name) {
    _courses.removeWhere((course) => course.courseName == course_name);
  }

  //show courses of teacher
  void showCourses() {
    _courses.forEach((course) {
      print("Course name: ${course.courseName}");
      print("Course description: ${course.courseDescription}");
    });
  }
}
