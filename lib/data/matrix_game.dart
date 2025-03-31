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

    return {
      "value": minimaxValue,
      "row": minimaxRow,
      "col": minimaxCol,
      "highlights": highlights,
    };
  }

  Map<String, List<bool>> findStrictlyDominatedStrategies() {
    int rows = matrixA.length;
    int cols = matrixA[0].length;

    List<bool> dominatedRows = List.filled(rows, false);
    List<bool> dominatedCols = List.filled(cols, false);

    bool changed = true;

    while (changed) {
      changed = false;

      // Проверяем строки (стратегии первого игрока)
      for (int i = 0; i < rows; i++) {
        if (dominatedRows[i]) continue; // Пропускаем уже отмеченные

        for (int j = 0; j < rows; j++) {
          if (i == j || dominatedRows[j])
            continue; // Не сравниваем с собой или отмеченными

          bool isDominated = true;

          // Проверяем, строго ли доминирует стратегия j над i
          for (int k = 0; k < cols; k++) {
            if (dominatedCols[k]) continue; // Пропускаем отмеченные столбцы

            if (matrixA[i][k] >= matrixA[j][k]) {
              isDominated = false;
              break;
            }
          }

          if (isDominated) {
            dominatedRows[i] = true;
            changed = true;
            break;
          }
        }
      }

      // Проверяем столбцы (стратегии второго игрока)
      for (int j = 0; j < cols; j++) {
        if (dominatedCols[j]) continue; // Пропускаем уже отмеченные

        for (int k = 0; k < cols; k++) {
          if (j == k || dominatedCols[k])
            continue; // Не сравниваем с собой или отмеченными

          bool isDominated = true;

          // Проверяем, строго ли доминирует стратегия k над j
          for (int i = 0; i < rows; i++) {
            if (dominatedRows[i]) continue; // Пропускаем отмеченные строки

            if (matrixB[i][j] >= matrixB[i][k]) {
              isDominated = false;
              break;
            }
          }

          if (isDominated) {
            dominatedCols[j] = true;
            changed = true;
            break;
          }
        }
      }
    }

    return {
      'rows':
          dominatedRows, // true - доминируемые строки (стратегии первого игрока)
      'cols':
          dominatedCols // true - доминируемые столбцы (стратегии второго игрока)
    };
  }
}
