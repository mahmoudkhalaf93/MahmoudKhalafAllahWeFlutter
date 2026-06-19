class Sheet {
  double _sheetNumber;
  String _description;
  String _fileName;
  Sheet(this._sheetNumber, this._description, this._fileName);

//setters
  set sheetNumber(double sheetNumber) => _sheetNumber = sheetNumber;
  set description(String description) => _description = description;
  set fileName(String fileName) => _fileName = fileName;

//getters
  double get sheetNumber => _sheetNumber;
  String get description => _description;
  String get fileName => _fileName;
}
