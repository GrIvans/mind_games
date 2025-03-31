import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:provider/provider.dart';

class NashBalanceScreenWidget extends StatelessWidget {
  const NashBalanceScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Равновесие по Нэшу"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Матрица первого игрока",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _HighlightedMatrixWidget(
                  matrix: provider.game.matrixA,
                  highlightCells:
                      provider.game.findPureNashEquilibria()["highlights"],
                ),
                const SizedBox(height: 20),
                const Text("Матрица второго игрока",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _HighlightedMatrixWidget(
                  matrix: provider.game.matrixA,
                  highlightCells:
                      provider.game.findPureNashEquilibria()["highlights"],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightedMatrixWidget extends StatelessWidget {
  final List<List<num>> matrix;
  final List<List<bool>> highlightCells;
  const _HighlightedMatrixWidget(
      {required this.matrix, required this.highlightCells});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(
          matrix.length,
          (i) => Row(
            children: List.generate(
              matrix[i].length,
              (j) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: highlightCells[i][j]
                        ? Colors.lightBlue.withValues(alpha: (0.3 * 255))
                        : null,
                    border: Border(
                      right: j < matrix[i].length - 1
                          ? BorderSide(color: Colors.grey)
                          : BorderSide.none,
                      bottom: i < matrix.length - 1
                          ? BorderSide(color: Colors.grey)
                          : BorderSide.none,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        '${matrix[i][j]}',
                        style: TextStyle(
                          fontWeight: highlightCells[i][j]
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
    );
  }
}
