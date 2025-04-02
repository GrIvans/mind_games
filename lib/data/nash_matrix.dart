import 'dart:math';

class NashMatrix {
  late List<List<double>> matrixA;
  late List<List<double>> matrixB;
  NashMatrix.zeroMatrix() {
    matrixA = List.generate(2, (_) => List.filled(2, 0.0));
    matrixB = List.generate(2, (_) => List.filled(2, 0.0));
  }

  NashMatrix(this.matrixA, this.matrixB);

  Map<String, double>? findEquilibrium() {
    double a = matrixA[0][0];
    double b = matrixA[0][1];
    double c = matrixA[1][0];
    double d = matrixA[1][1];

    double e = matrixB[0][0];
    double f = matrixB[0][1];
    double g = matrixB[1][0];
    double h = matrixB[1][1];

    double denominatorP = (a - e) + (g - c);

    double denominatorQ = (b - f) + (h - d);

    if (denominatorQ == 0 || denominatorP == 0) return null;

    double pNumerator = g - e;
    double p = pNumerator / denominatorP;

    double qNumerator = h - f;
    double q = qNumerator / denominatorQ;

    if (p < 0 || p > 1.0 || q < 0 || q > 1.0) {
      return null;
    }

    p = max(0.0, min(1.0, p));
    q = max(0.0, min(1.0, q));

    return {'p': p, 'q': q};
  }
}
