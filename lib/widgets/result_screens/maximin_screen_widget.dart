import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:provider/provider.dart';

class MaximinScreenWidget extends StatefulWidget {
  const MaximinScreenWidget({super.key});

  @override
  State<MaximinScreenWidget> createState() => _MaximinScreenWidgetState();
}

class _MaximinScreenWidgetState extends State<MaximinScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Максимин и Минимакс"),),
    );
  }
}