import 'teacher.dart';

class Coursera {
  List<Teacher> _teachers = [];

//add teacher to coursera
  Teacher? register(Teacher teacher) {
    _teachers.add(teacher);
    return teacher;
  }

//setters
  set teachers(List<Teacher> teachers) => _teachers = teachers;
  //getters
  List<Teacher> get teachers => _teachers;

  //login teacher
  Teacher? login(String name, String password) {
    bool not_found = true;
    Teacher? loggedInTeacher = null;
    _teachers.forEach((teacher) {
      if (teacher.name == name && teacher.password == password) {
        loggedInTeacher = teacher;
        print("Login successful welcome ${teacher.name}");
        not_found = false;
      }
    });
    if (not_found) {
      print("Login failed");
      return null;
    } else {
      return loggedInTeacher;
    }
  }
}
