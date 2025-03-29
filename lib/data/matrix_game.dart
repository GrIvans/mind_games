class MatrixGame {
  List<List<num>> _matrixA = [];
  List<List<num>> _matrixB = [];

  MatrixGame(List<List<num>> matrixA, matrixB) {
    _matrixA = matrixA;
    _matrixB = matrixB;
  }

  MatrixGame.generateMatrix(int rows, int cols, {num initialValue = 0}) {
    var matrixA = List.generate(rows, (_) => List.filled(cols, initialValue));
    var matrixB = List.generate(rows, (_) => List.filled(cols, initialValue));
    MatrixGame(matrixA, matrixB);
  }

  List<List<num>> get matrixA => _matrixA;
  List<List<num>> get matrixB => _matrixB;

  set MatrixA(List<List<num>> matrix) {
    _matrixA = matrix;
  }

  set MatrixB(List<List<num>> matrix) {
    _matrixB = matrix;
  }

  Map<String, dynamic> findMaximin() {
    num maximinValue = double.negativeInfinity.toInt();
    int maximinRow = -1;

    for (int i = 0; i < _matrixA.length; i++) {
      num rowMin = _matrixA[i].reduce((a, b) => a < b ? a : b);
      if (rowMin > maximinValue) {
        maximinValue = rowMin;
        maximinRow = i;
      }
    }

    return {
      'value': maximinValue,
      'row': maximinRow,
      'col': _matrixA[maximinRow].indexOf(maximinValue),
    };
  }

  Map<String, dynamic> findMinimax() {
    num minimaxValue = double.infinity.toInt();
    int minimaxRow = -1, minimaxCol = -1;

    for (int j = 0; j < _matrixB[0].length; j++) {
      num colMax = double.negativeInfinity.toInt();
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

    return {
      'value': minimaxValue,
      'row': minimaxRow,
      'col': minimaxCol,
    };
  }
}
