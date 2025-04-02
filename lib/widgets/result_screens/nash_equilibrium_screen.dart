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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Поиск равновесия по Нэшу в смешанных стратегиях",
          maxLines: 2,
        ),
      ),
      body: Column(children: [
        MatrixWidget(rows: 2, cols: 2, controllers: )
      ],),
    );
  }
}
