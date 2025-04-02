import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mind_games/data/nash_matrix.dart';
import 'package:mind_games/widgets/matrix_input_screen_widget.dart';

class NashEquilibriumScreen extends StatefulWidget {
  const NashEquilibriumScreen({super.key});

  @override
  State<NashEquilibriumScreen> createState() => _NashEquilibriumScreenState();
}

class _NashEquilibriumScreenState extends State<NashEquilibriumScreen> {
  NashMatrix game = NashMatrix.zeroMatrix();
  late List<List<TextEditingController>> controllersA;
  late List<List<TextEditingController>> controllersB;
  TextEditingController pController = TextEditingController(text: "0.5");
  TextEditingController qController = TextEditingController(text: "0.5");
  String _answer = "";

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    controllersA = List.generate(
      2,
      (i) => List.generate(
        2,
        (j) => TextEditingController(text: game.matrixA[i][j].toString()),
      ),
    );

    controllersB = List.generate(
      2,
      (i) => List.generate(
        2,
        (j) => TextEditingController(
            text: (j < game.matrixB[i].length ? game.matrixB[i][j] : 0.0)
                .toString()),
      ),
    );
  }

  void _generateRandomData() {
    setState(() {
      Random random = Random();
      if (game.matrixA.length != 2 ||
          (game.matrixA.isNotEmpty && game.matrixA[0].length != 2)) {
        game.matrixA = List.generate(2, (_) => List.filled(2, 0.0));
        game.matrixB = List.generate(2, (_) => List.filled(2, 0.0));
        initializeControllers();
      }

      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          double valueA = (random.nextDouble() * 10).roundToDouble();
          double valueB = (random.nextDouble() * 10).roundToDouble();
          game.matrixA[i][j] = valueA;
          game.matrixB[i][j] = valueB;
          controllersA[i][j].text = valueA.toString();
          controllersB[i][j].text = valueB.toString();
        }
      }
    });
  }

  void findEquilibrium() {
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 2; j++) {
        game.matrixA[i][j] = double.tryParse(controllersA[i][j].text) ?? 0.0;
        game.matrixB[i][j] = double.tryParse(controllersB[i][j].text) ?? 0.0;
      }
    }
    Map<String, double>? result = game.findEquilibrium();

    setState(() {
      _answer = "Решение не найдено. Вероятности вне диапазона.";
      if (result != null) {
        _answer =
            "Равновесие Нэша в смешанных стратегиях:\nИгрок A: (${result["p"]!.toStringAsFixed(2)}, ${(1 - result["p"]!).toStringAsFixed(2)})\nИгрок B:(${result["q"]!.toStringAsFixed(2)}, ${(1 - result["q"]!).toStringAsFixed(2)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Поиск равновесия по Нэшу в смешанных стратегиях",
          maxLines: 2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Матрица для игрока A",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MatrixWidget(
                rows: 2,
                cols: 2,
                controllers: controllersA,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Матрица для игрока B",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MatrixWidget(
                rows: 2,
                cols: 2,
                controllers: controllersB,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                FilledButton(
                  onPressed: findEquilibrium,
                  child: Text("Найти равновесие Нэша"),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                      onPressed: _generateRandomData,
                      child: Text("Сгенерировать значения")),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _answer,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
