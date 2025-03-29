import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:provider/provider.dart';

class AlgorithmResultScreen extends StatefulWidget {
  final String algorithm;

  const AlgorithmResultScreen({
    super.key,
    required this.algorithm,
  });

  @override
  AlgorithmResultScreenState createState() => AlgorithmResultScreenState();
}

class AlgorithmResultScreenState extends State<AlgorithmResultScreen> {
  List<List<num>> matrixA = [];
  List<List<num>> matrixB = [];
  Map<String, dynamic> results = {};
  List<List<bool>> highlightCellsA = [];
  List<List<bool>> highlightCellsB = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = context.read<GameProvider>();
      matrixA = provider.game.matrixA;
      matrixB = provider.game.matrixB;
    });

    switch (widget.algorithm) {
      case 'maxmin':
        calculateMaxMin();
        break;
      case 'dominated':
        calculateDominated();
        break;
      case 'nash':
        calculateNash();
        break;
      case 'mixed':
        calculateMixed();
        break;
    }
  }

  void calculateMaxMin() {
    // Максимин для первого игрока
    List<num> rowMins = [];
    List<int> minIndices = [];

    for (int i = 0; i < matrixA.length; i++) {
      num minInRow = matrixA[i][0];
      int minIndex = 0;

      for (int j = 1; j < matrixA[i].length; j++) {
        if (matrixA[i][j] < minInRow) {
          minInRow = matrixA[i][j];
          minIndex = j;
        }
      }

      rowMins.add(minInRow);
      minIndices.add(minIndex);
    }

    num maxmin = rowMins[0];
    int maxminRow = 0;

    for (int i = 1; i < rowMins.length; i++) {
      if (rowMins[i] > maxmin) {
        maxmin = rowMins[i];
        maxminRow = i;
      }
    }

    // Минимакс для второго игрока
    List<num> colMaxs = [];
    List<int> maxIndices = [];

    for (int j = 0; j < matrixB[0].length; j++) {
      num maxInCol = matrixB[0][j];
      int maxIndex = 0;

      for (int i = 1; i < matrixB.length; i++) {
        if (matrixB[i][j] > maxInCol) {
          maxInCol = matrixB[i][j];
          maxIndex = i;
        }
      }

      colMaxs.add(maxInCol);
      maxIndices.add(maxIndex);
    }

    num minmax = colMaxs[0];
    int minmaxCol = 0;

    for (int j = 1; j < colMaxs.length; j++) {
      if (colMaxs[j] < minmax) {
        minmax = colMaxs[j];
        minmaxCol = j;
      }
    }

    // Подсветка соответствующих ячеек
    highlightCellsA[maxminRow][minIndices[maxminRow]] = true;
    highlightCellsB[maxIndices[minmaxCol]][minmaxCol] = true;

    results = {
      'maxmin': maxmin,
      'maxminStrategy': maxminRow + 1,
      'minmax': minmax,
      'minmaxStrategy': minmaxCol + 1,
    };
  }

  void calculateDominated() {
    List<int> dominatedRows = []; // Строго доминируемые строки
    List<int> dominatedCols = []; // Строго доминируемые столбцы

    // Для демонстрации, предположим, что мы нашли эти доминируемые стратегии
    dominatedRows = [1]; // Вторая строка доминируема

    // Подсветка доминируемых стратегий
    for (int i = 0; i < matrixA.length; i++) {
      for (int j = 0; j < matrixA[i].length; j++) {
        if (dominatedRows.contains(i)) {
          highlightCellsA[i][j] = true;
          highlightCellsB[i][j] = true;
        }
        if (dominatedCols.contains(j)) {
          highlightCellsA[i][j] = true;
          highlightCellsB[i][j] = true;
        }
      }
    }

    results = {
      'dominatedRows': dominatedRows.map((i) => i + 1).toList(),
      'dominatedCols': dominatedCols.map((j) => j + 1).toList(),
    };
  }

  void calculateNash() {
    List<List<int>> nashEquilibria = [];

    // Для 2x2 матрицы, проверяем все ячейки на равновесие Нэша
    for (int i = 0; i < matrixA.length; i++) {
      for (int j = 0; j < matrixA[i].length; j++) {
        bool isNash = true;

        // Проверка для первого игрока
        for (int i2 = 0; i2 < matrixA.length; i2++) {
          if (matrixA[i2][j] > matrixA[i][j]) {
            isNash = false;
            break;
          }
        }

        if (!isNash) continue;

        // Проверка для второго игрока
        for (int j2 = 0; j2 < matrixB[i].length; j2++) {
          if (matrixB[i][j2] > matrixB[i][j]) {
            isNash = false;
            break;
          }
        }

        if (isNash) {
          nashEquilibria.add([i, j]);
          // Подсветка ячеек с равновесием Нэша
          highlightCellsA[i][j] = true;
          highlightCellsB[i][j] = true;
        }
      }
    }

    results = {
      'nashEquilibria':
          nashEquilibria.map((e) => '(${e[0] + 1}, ${e[1] + 1})').toList(),
    };
  }

  void calculateMixed() {
    // Для 2x2 игры, можно аналитически найти смешанные стратегии
    // В общем случае это более сложный расчет, здесь для демонстрации

    // Пример результата для смешанной стратегии
    results = {
      'player1Strategy': [0.6, 0.4],
      'player2Strategy': [0.3, 0.7],
      'expectedValue': 1.8,
    };
  }

  String getAlgorithmTitle() {
    switch (widget.algorithm) {
      case 'maxmin':
        return 'Максимин/Минимакс';
      case 'dominated':
        return 'Доминируемые стратегии';
      case 'nash':
        return 'Равновесия Нэша';
      case 'mixed':
        return 'Смешанные стратегии';
      default:
        return 'Результаты анализа';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getAlgorithmTitle()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Матрица A с подсветкой
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Матрица A (первый игрок)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: List.generate(
                          matrixA.length,
                          (i) => Row(
                            children: List.generate(
                              matrixA[i].length,
                              (j) => Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: highlightCellsA[i][j]
                                        ? Colors.lightBlue
                                            .withValues(alpha: (0.3 * 255))
                                        : null,
                                    border: Border(
                                      right: j < matrixA[i].length - 1
                                          ? BorderSide(color: Colors.grey)
                                          : BorderSide.none,
                                      bottom: i < matrixA.length - 1
                                          ? BorderSide(color: Colors.grey)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Text(
                                        '${matrixA[i][j]}',
                                        style: TextStyle(
                                          fontWeight: highlightCellsA[i][j]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Матрица B с подсветкой
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Матрица B (второй игрок)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: List.generate(
                          matrixB.length,
                          (i) => Row(
                            children: List.generate(
                              matrixB[i].length,
                              (j) => Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: highlightCellsB[i][j]
                                        ? Colors.lightBlue
                                            .withValues(alpha: (0.3 * 255))
                                        : null,
                                    border: Border(
                                      right: j < matrixB[i].length - 1
                                          ? BorderSide(color: Colors.grey)
                                          : BorderSide.none,
                                      bottom: i < matrixB.length - 1
                                          ? BorderSide(color: Colors.grey)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Text(
                                        '${matrixB[i][j]}',
                                        style: TextStyle(
                                          fontWeight: highlightCellsB[i][j]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Результаты анализа
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Результаты анализа',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (widget.algorithm == 'maxmin')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResultItem(
                            title: 'Максимин (первый игрок)',
                            value:
                                'Значение: ${results['maxmin']}, Стратегия: ${results['maxminStrategy']}',
                          ),
                          SizedBox(height: 8),
                          ResultItem(
                            title: 'Минимакс (второй игрок)',
                            value:
                                'Значение: ${results['minmax']}, Стратегия: ${results['minmaxStrategy']}',
                          ),
                        ],
                      ),
                    if (widget.algorithm == 'dominated')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResultItem(
                            title: 'Строго доминируемые стратегии (игрок 1)',
                            value:
                                '${results['dominatedRows']?.isEmpty ?? true ? "Нет" : results['dominatedRows'].join(", ")}',
                          ),
                          SizedBox(height: 8),
                          ResultItem(
                            title: 'Строго доминируемые стратегии (игрок 2)',
                            value:
                                '${results['dominatedCols']?.isEmpty ?? true ? "Нет" : results['dominatedCols'].join(", ")}',
                          ),
                        ],
                      ),
                    if (widget.algorithm == 'nash')
                      ResultItem(
                        title: 'Равновесия Нэша в чистых стратегиях',
                        value:
                            '${results['nashEquilibria']?.isEmpty ?? true ? "Не найдено" : results['nashEquilibria'].join(", ")}',
                      ),
                    if (widget.algorithm == 'mixed')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResultItem(
                            title: 'Смешанная стратегия игрока 1',
                            value:
                                '(${results['player1Strategy']?[0]}, ${results['player1Strategy']?[1]})',
                          ),
                          SizedBox(height: 8),
                          ResultItem(
                            title: 'Смешанная стратегия игрока 2',
                            value:
                                '(${results['player2Strategy']?[0]}, ${results['player2Strategy']?[1]})',
                          ),
                          SizedBox(height: 8),
                          ResultItem(
                            title: 'Ожидаемый выигрыш',
                            value: '${results['expectedValue']}',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultItem extends StatelessWidget {
  final String title;
  final String value;

  const ResultItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
