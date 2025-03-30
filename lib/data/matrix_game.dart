class MatrixGame {
  List<List<num>> _matrixA = [];
  List<List<num>> _matrixB = [];

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

  List<List<bool>> findMaximin() {
    // Создаем матрицу флагов с теми же размерами, что и _matrixA, заполненную false
    List<List<bool>> highlights = List.generate(
      _matrixA.length,
      (i) => List.filled(_matrixA[i].length, false),
    );

    num maximinValue = double.negativeInfinity;
    int maximinRow = -1, maximinCol = -1;

    for (int i = 0; i < _matrixA.length; i++) {
      // Приводим к double, чтобы избежать проблем с типами
      num rowMin = _matrixA[i].cast<double>().reduce((a, b) => a < b ? a : b);
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

    return highlights;
  }

  /// Для второго игрока: выделяем ячейку с минимаксом
  List<List<bool>> findMinimax() {
    // Создаем матрицу флагов с теми же размерами, что и _matrixB, заполненную false
    List<List<bool>> highlights = List.generate(
      _matrixB.length,
      (i) => List.filled(_matrixB[i].length, false),
    );

    num minimaxValue = double.infinity;
    int minimaxRow = -1, minimaxCol = -1;

    for (int j = 0; j < _matrixB[0].length; j++) {
      num colMax = double.negativeInfinity;
      int rowIndex = -1;
      for (int i = 0; i < _matrixB.length; i++) {
        if (_matrixB[i][j] > colMax) {
          colMax = _matrixB[i][j];
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

    return highlights;
  }
}
