import 'package:flutter/foundation.dart';
import 'package:mind_games/data/matrix.dart';

class MatrixProvider with ChangeNotifier {
  Matrix _matrixA;
  Matrix _matrixB;

  MatrixProvider({int rows = 2, int cols = 2, num initialValue = 0})
      : _matrixA = Matrix(rows, cols, initialValue: initialValue),
        _matrixB = Matrix(rows, cols, initialValue: initialValue);

  Matrix get matrixA => _matrixA;
  Matrix get matrixB => _matrixB;

  void setMatrixA(Matrix matrixA) {
    _matrixA = matrixA;
    notifyListeners();
  }

  void setMatrixB(Matrix matrixB) {
    _matrixB = matrixB;
    notifyListeners();
  }
}
