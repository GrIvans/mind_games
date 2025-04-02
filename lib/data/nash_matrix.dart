class NashMatrix {
  late List<List<num>> matrixA;
  late List<List<num>> matrixB;

  NashMatrix.zeroMatrix() {
    matrixA = List.generate(2, (_) => List.filled(2, 0));
    matrixB = List.generate(2, (_) => List.filled(2, 0));
    NashMatrix(matrixA, matrixB);
  }
  NashMatrix(this.matrixA, this.matrixB);

  /// Метод для вычисления смешанного равновесия по Нэшу.
  /// Возвращает Map с ключами 'p' и 'q', где
  /// p - вероятность выбора первой стратегии игроком 1,
  /// q - вероятность выбора первой стратегии игроком 2.
  /// Если равновесие не найдено (или игра вырожденная), возвращает null.
  Map<String, num>? findEquilibrium() {
    // Для игрока 1: условие безразличия между стратегиями:
    // q * matrixA[0][0] + (1 - q) * matrixA[0][1] = q * matrixA[1][0] + (1 - q) * matrixA[1][1]
    num denominatorQ =
        (matrixA[0][0] - matrixA[0][1]) - (matrixA[1][0] - matrixA[1][1]);

    if (denominatorQ == 0) {
      return null;
    }

    num q = (matrixA[1][1] - matrixA[0][1]) / denominatorQ;

    // Для игрока 2: условие безразличия между стратегиями:
    // p * matrixB[0][0] + (1 - p) * matrixB[1][0] = p * matrixB[0][1] + (1 - p) * matrixB[1][1]
    num denominatorP =
        (matrixB[0][0] - matrixB[1][0]) - (matrixB[0][1] - matrixB[1][1]);

    if (denominatorP == 0) {
      return null;
    }

    double p = (matrixB[1][1] - matrixB[1][0]) / denominatorP;

    // Проверка, что вероятности находятся в диапазоне [0, 1]
    if (p < 0 || p > 1 || q < 0 || q > 1) {
      return null;
    }

    return {'p': p, 'q': q};
  }
}
