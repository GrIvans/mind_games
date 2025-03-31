import 'package:flutter/material.dart';

class MatrixGame {
  List<List<num>> _matrixA = [];
  List<List<num>> _matrixB = [];
  bool singleMatrixGame = false;

  MatrixGame(List<List<num>> matrixA, List<List<num>> matrixB) {
    _matrixA = matrixA;
    _matrixB = matrixB;
  }

  MatrixGame.generateMatrix(int rows, int cols, {num initialValue = 0}) {
    _matrixA = List.generate(rows, (_) => List.filled(cols, initialValue));
    _matrixB = List.generate(rows, (_) => List.filled(cols, initialValue));
  }

  List<List<num>> get matrixA => _matrixA;
  List<List<num>> get matrixB => _matrixB;

  set matrixA(List<List<num>> matrix) {
    _matrixA = matrix;
  }

  set matrixB(List<List<num>> matrix) {
    _matrixB = matrix;
  }

  Map<String, dynamic> findMaximin() {
    // Создаем матрицу флагов с теми же размерами, что и _matrixA, заполненную false
    List<List<bool>> highlights = List.generate(
      _matrixA.length,
      (i) => List.filled(_matrixA[i].length, false),
    );

    num maximinValue = double.negativeInfinity;
    int maximinRow = -1, maximinCol = -1;

    for (int i = 0; i < _matrixA.length; i++) {
      num rowMin = _matrixA[i].cast<num>().reduce((a, b) => a < b ? a : b);
      if (rowMin > maximinValue) {
        maximinValue = rowMin;
        maximinRow = i;
        maximinCol = _matrixA[i].indexOf(rowMin);
      }
    }

    // Если нашли корректную строку и столбец, подсвечиваем найденную ячейку
    if (maximinRow != -1 && maximinCol != -1) {
      highlights[maximinRow][maximinCol] = true;
    }

    return {
      "value": maximinValue,
      "row": maximinRow,
      "col": maximinCol,
      "highlights": highlights,
    };
  }

  /// Для второго игрока: выделяем ячейку с минимаксом
  Map<String, dynamic> findMinimax() {
    // Создаем матрицу флагов с теми же размерами, что и _matrixB, заполненную false
    List<List<bool>> highlights = List.generate(
      _matrixA.length,
      (i) => List.filled(_matrixA[i].length, false),
    );

    num minimaxValue = double.infinity;
    int minimaxRow = -1, minimaxCol = -1;

    for (int j = 0; j < _matrixA[0].length; j++) {
      num colMax = double.negativeInfinity;
      int rowIndex = -1;
      for (int i = 0; i < _matrixA.length; i++) {
        if (_matrixA[i][j] > colMax) {
          colMax = _matrixA[i][j];
          rowIndex = i;
        }
      }
      if (colMax < minimaxValue) {
        minimaxValue = colMax;
        minimaxRow = rowIndex;
        minimaxCol = j;
      }
    }

    if (minimaxRow != -1 && minimaxCol != -1) {
      highlights[minimaxRow][minimaxCol] = true;
    }

    return {
      "value": minimaxValue,
      "row": minimaxRow,
      "col": minimaxCol,
      "highlights": highlights,
    };
  }

  Map<String, dynamic> findPureNashEquilibria() {
    int numRows = _matrixA.length;
    int numCols = _matrixA[0].length;

    var bestResponseA = findColumnMaxima(matrixA);
    var bestResponseB = findRowMaxima(matrixB);

    // 3. Найти ячейки, где оба ответа являются наилучшими
    var highlighted =
        List.generate(numRows, (_) => List.filled(numCols, false));

    for (var mA in bestResponseA) {
      for (var mB in bestResponseB) {
        if (mA["row"] == mB["row"] && mA["col"] == mB["col"]) {
          highlighted[mA["row"]][mA["col"]] = true;
        }
      }
    }

    return {"highlights": highlighted};
  }

  List<Map<String, dynamic>> findColumnMaxima(List<List<num>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) {
      throw ArgumentError("Матрица не должна быть пустой");
    }

    int rowCount = matrix.length;
    int colCount = matrix[0].length;
    List<Map<String, dynamic>> result = [];

    for (int col = 0; col < colCount; col++) {
      num maxVal = matrix[0][col];
      int maxRow = 0;

      for (int row = 1; row < rowCount; row++) {
        if (matrix[row][col] > maxVal) {
          maxVal = matrix[row][col];
          maxRow = row;
        }
      }

      result.add({"value": maxVal, "row": maxRow, "col": col});
    }

    return result;
  }

  List<Map<String, dynamic>> findRowMaxima(List<List<num>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) {
      throw ArgumentError("Матрица не должна быть пустой");
    }

    int rowCount = matrix.length;
    int colCount = matrix[0].length;
    List<Map<String, dynamic>> result = [];

    for (int row = 0; row < rowCount; row++) {
      num maxVal = matrix[row][0];
      int maxCol = 0;

      for (int col = 1; col < colCount; col++) {
        if (matrix[row][col] > maxVal) {
          maxVal = matrix[row][col];
          maxCol = col;
        }
      }

      result.add({"value": maxVal, "row": row, "col": maxCol});
    }

    return result;
  }
}
