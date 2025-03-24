import 'dart:math';
import 'package:flutter/material.dart';

class MatrixInputScreen extends StatefulWidget {
  const MatrixInputScreen({super.key});

  @override
  MatrixInputScreenState createState() => MatrixInputScreenState();
}

class MatrixInputScreenState extends State<MatrixInputScreen> {
  int rows = 2;
  int cols = 2;
  List<List<double>> matrixA = [];
  List<List<double>> matrixB = [];
  List<List<TextEditingController>> controllersA = [];
  List<List<TextEditingController>> controllersB = [];

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
    Navigator.pop(context, (matrixA, matrixB));
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

            // Текущая матрица (A или B)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Матрица выигрышей первого игрока (A)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: generateMatrixWidget(showMatrixB: false),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: generateMatrixWidget(showMatrixB: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: saveMatrix, label: Text("Сохранить")),
    );
  }

  Widget generateMatrixWidget({required bool showMatrixB}) {
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
