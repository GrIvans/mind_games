import 'package:flutter/material.dart';
import 'package:mind_games/widgets/home_screen_widget.dart';

void main() {
  runApp(GameTheoryApp());
}

class GameTheoryApp extends StatelessWidget {
  const GameTheoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Теория игр',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
