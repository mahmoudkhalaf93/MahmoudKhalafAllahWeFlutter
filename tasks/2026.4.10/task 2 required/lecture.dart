class Lecture {
  String _lectureName, _description, _fileName;

  Lecture(this._lectureName, this._description, this._fileName);

  //setters
  set lectureName(String lectureName) => _lectureName = lectureName;
  set description(String description) => _description = description;
  set fileName(String fileName) => _fileName = fileName;

  //getters
  String get lectureName => _lectureName;
  String get description => _description;
  String get fileName => _fileName;
}
