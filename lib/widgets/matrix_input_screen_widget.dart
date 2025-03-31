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
  int rows = 2;
  int cols = 2;
  List<List<num>> matrixA = [];
  List<List<num>> matrixB = [];
  List<List<TextEditingController>> controllersA = [];
  List<List<TextEditingController>> controllersB = [];
  int screenIndex = 1;
  @override
  void initState() {
    super.initState();
    initializeMatrices();
  }

  void initializeMatrices() {
    matrixA = List.generate(rows, (_) => List.filled(cols, 0.0));
    matrixB = List.generate(rows, (_) => List.filled(cols, 0.0));

    controllersA = List.generate(
      rows,
      (i) => List.generate(
        cols,
        (j) => TextEditingController(text: '0.0'),
      ),
    );

    controllersB = List.generate(
      rows,
      (i) => List.generate(
        cols,
        (j) => TextEditingController(text: '0.0'),
      ),
    );
  }

  void updateMatrixDimensions(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
      initializeMatrices();
    });
  }

  void generateRandomData() {
    setState(() {
      Random random = Random();
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
        matrixA[i][j] = num.parse(controllersA[i][j].text);
        matrixB[i][j] = num.parse(controllersB[i][j].text);
      }
    }
    if (screenIndex == 0) {
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
          matrixB[i][j] = 0 - matrixA[i][j];
        }
      }
    }
    context.read<GameProvider>().setMatrixB(matrixB);
    context.read<GameProvider>().setMatrixA(matrixA);
    Navigator.pushReplacementNamed(context, "/home");
  }

  void _changeScreen(bool? newValue) {
    setState(() {
      if (newValue != null) screenIndex = newValue ? 1 : 0;
    });
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
                                  controllersB: controllersB,
                                  controllersA: controllersA,
                                  showMatrixB: false),
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
                                  controllersB: controllersB,
                                  controllersA: controllersA,
                                  showMatrixB: false),
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
                                  controllersB: controllersB,
                                  controllersA: controllersA,
                                  showMatrixB: true),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    required this.controllersB,
    required this.controllersA,
    required this.showMatrixB,
  });

  final int rows;
  final int cols;
  final List<List<TextEditingController>> controllersB;
  final List<List<TextEditingController>> controllersA;
  final bool showMatrixB;

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
                    controller:
                        showMatrixB ? controllersB[i][j] : controllersA[i][j],
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
