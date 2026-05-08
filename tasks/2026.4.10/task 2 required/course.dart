import 'lecture.dart';
import 'sheet.dart';

class Course {
  String _name;
  String _description;
  List<Lecture> _lectures = [];
  List<Sheet> _sheets = [];

  Course(this._name, this._description);
//setters
  set courseName(String name) => this._name = name;
  set courseDescription(String description) => this._description = description;
  //getters
  String get courseName => _name;
  String get courseDescription => _description;

  //add lecture to course
  void addLecture(Lecture lecture) {
    _lectures.add(lecture);
  }

  //delete lecture from course
  void deleteLecture(String lecture_name) {
    _lectures.removeWhere((lecture) => lecture.lectureName == lecture_name);
  }

  //add sheet to course
  void addSheet(Sheet sheet) {
    _sheets.add(sheet);
  }

  //delete sheet from course
  void deleteSheet(double sheet_number) {
    _sheets.removeWhere((sheet) => sheet.sheetNumber == sheet_number);
  }
}
