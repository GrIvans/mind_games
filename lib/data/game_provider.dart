import 'package:flutter/foundation.dart';
import 'package:mind_games/data/matrix_game.dart';

class GameProvider with ChangeNotifier {
  final MatrixGame _game;
  bool isDarkThemeActivated = false;

  GameProvider({int rows = 2, int cols = 2, num initialValue = 0})
      : _game =
            MatrixGame.generateMatrix(rows, cols, initialValue: initialValue);

  MatrixGame get game => _game;

  void setMatrixA(List<List<num>> matrixA) {
    _game.matrixA = matrixA;
    notifyListeners();
  }

  void setGameType(bool gameType) {
    _game.singleMatrixGame = gameType;
    notifyListeners();
  }

  void setMatrixB(List<List<num>> matrixB) {
    _game.matrixB = matrixB;
    notifyListeners();
  }

  void setDarkThemeStatus(bool darkTheme) {
    isDarkThemeActivated = darkTheme;
    notifyListeners();
  }
}
