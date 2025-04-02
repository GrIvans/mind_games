class Matrix {
  late List<List<num>> _data;

  Matrix(int rows, int cols, {num initialValue = 0}) {
    _data = List.generate(rows, (_) => List.filled(cols, initialValue));
  }

  Matrix.fromList(List<List<num>> data)
      : _data = data.map((row) => List<num>.from(row)).toList();

  int get rowCount => _data.length;
  int get colCount => _data.isNotEmpty ? _data[0].length : 0;
  List<List<num>> get list => _data;

  void replaceWith(Matrix other) {
    _data = other._data.map((row) => List<num>.from(row)).toList();
  }

  void replaceWithList(List<List<num>> data) {
    _data = data.map((row) => List<num>.from(row)).toList();
  }

  List<num> operator [](int row) => _data[row];

  @override
  String toString() => _data.map((row) => row.join(" ")).join("\n");
}
