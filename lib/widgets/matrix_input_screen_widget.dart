import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:provider/provider.dart';

class MatrixInputScreen extends StatefulWidget {
  const MatrixInputScreen({super.key});

  @override
  MatrixInputScreenState createState() => MatrixInputScreenState();
}

class MatrixInputScreenState extends State<MatrixInputScreen> {
  late int rows;
  late int cols;
  late List<List<num>> matrixA;
  late List<List<num>> matrixB;
  late List<List<TextEditingController>> controllersA;
  late List<List<TextEditingController>> controllersB;
  // int screenIndex = 1;
  late int screenIndex;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);

      final initialMatrixA = gameProvider.game.matrixA;
      final initialMatrixB = gameProvider.game.matrixB;
      screenIndex = gameProvider.game.singleMatrixGame ? 0 : 1;

      if (initialMatrixA.isNotEmpty && initialMatrixA[0].isNotEmpty) {
        rows = initialMatrixA.length;
        cols = initialMatrixA[0].length;
        matrixA = List.generate(rows, (i) => List<num>.from(initialMatrixA[i]));

        if (initialMatrixB.length == rows && initialMatrixB[0].length == cols) {
          matrixB =
              List.generate(rows, (i) => List<num>.from(initialMatrixB[i]));
        } else {
          matrixB = List.generate(rows, (_) => List.filled(cols, 0.0));
        }
      } else {
        rows = 2;
        cols = 2;
        matrixA = List.generate(rows, (_) => List.filled(cols, 0.0));
        matrixB = List.generate(rows, (_) => List.filled(cols, 0.0));
      }

      initializeControllers();

      _isInitialized = true;
    }
  }

  void initializeControllers() {
    controllersA = List.generate(
      rows,
      (i) => List.generate(
        cols,
        (j) => TextEditingController(text: matrixA[i][j].toString()),
      ),
    );

    controllersB = List.generate(
      rows,
      (i) => List.generate(
        cols,
        (j) => TextEditingController(
            text: (j < matrixB[i].length ? matrixB[i][j] : 0.0).toString()),
      ),
    );
  }

  void updateMatrixDimensions(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
      matrixA = List.generate(rows, (_) => List.filled(cols, 0.0));
      matrixB = List.generate(rows, (_) => List.filled(cols, 0.0));
      initializeControllers();
    });
  }

  void generateRandomData() {
    setState(() {
      Random random = Random();
      if (matrixA.length != rows ||
          (matrixA.isNotEmpty && matrixA[0].length != cols)) {
        matrixA = List.generate(rows, (_) => List.filled(cols, 0.0));
        matrixB = List.generate(rows, (_) => List.filled(cols, 0.0));
        initializeControllers();
      }

      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          double valueA = (random.nextDouble() * 10).roundToDouble();
          double valueB = (random.nextDouble() * 10).roundToDouble();
          matrixA[i][j] = valueA;
          matrixB[i][j] = valueB;
          controllersA[i][j].text = valueA.toString();
          controllersB[i][j].text = valueB.toString();
        }
      }
    });
  }

  void saveMatrix() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        matrixA[i][j] = num.tryParse(controllersA[i][j].text) ?? 0.0;
        matrixB[i][j] = num.tryParse(controllersB[i][j].text) ?? 0.0;
      }
    }

    if (screenIndex == 0) {
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
          matrixB[i][j] = 0 - matrixA[i][j];
        }
      }
    }

    final gameProvider = context.read<GameProvider>();
    gameProvider.setGameType(screenIndex == 0 ? true : false);
    gameProvider.setMatrixA(List.generate(rows, (i) => List.from(matrixA[i])));
    gameProvider.setMatrixB(List.generate(rows, (i) => List.from(matrixB[i])));

    Navigator.pushReplacementNamed(context, "/home");
  }

  void _changeScreen(bool? newValue) {
    setState(() {
      if (newValue != null) screenIndex = newValue ? 1 : 0;
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < controllersA.length; i++) {
      for (int j = 0; j < controllersA[i].length; j++) {
        controllersA[i][j].dispose();
      }
    }
    for (int i = 0; i < controllersB.length; i++) {
      for (int j = 0; j < controllersB[i].length; j++) {
        controllersB[i][j].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод матрицы'),
        leading: SizedBox(
          width: 10,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Размеры матрицы
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Размеры матрицы',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Строки:'),
                              SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: rows,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                ),
                                items: [2, 3, 4, 5].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    updateMatrixDimensions(newValue, cols);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Столбцы:'),
                              SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: cols,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                ),
                                items: [2, 3, 4, 5].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value'),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    updateMatrixDimensions(rows, newValue);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: generateRandomData,
                      icon: Icon(Icons.shuffle),
                      label: Text('Сгенерировать случайные значения'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4),
            Row(
              children: [
                Checkbox(
                    value: screenIndex == 0 ? false : true,
                    onChanged: (value) => _changeScreen(value)),
                Text("Использовать биматричную модель"),
              ],
            ),
            IndexedStack(
              index: screenIndex,
              children: [
                // одна матрица
                Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Матрица выигрышей',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: MatrixWidget(
                                rows: rows,
                                cols: cols,
                                controllers: controllersA,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // биматричные модели
                Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Матрица выигрышей первого игрока (A)',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: MatrixWidget(
                                rows: rows,
                                cols: cols,
                                controllers: controllersA,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Матрица выигрышей второго игрока (B)',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: MatrixWidget(
                                rows: rows,
                                cols: cols,
                                controllers: controllersB,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveMatrix,
        label: Text("Сохранить"),
      ),
    );
  }
}

class MatrixWidget extends StatelessWidget {
  const MatrixWidget({
    super.key,
    required this.rows,
    required this.cols,
    required this.controllers,
  });

  final int rows;
  final int cols;
  final List<List<TextEditingController>> controllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rows,
        (i) => Row(
          children: List.generate(
            cols,
            (j) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: j < cols - 1
                        ? BorderSide(color: Colors.grey)
                        : BorderSide.none,
                    bottom: i < rows - 1
                        ? BorderSide(color: Colors.grey)
                        : BorderSide.none,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: TextField(
                    controller: controllers[i][j],
                    textAlign: TextAlign.center,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Компонент для отображения результатов анализа
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
