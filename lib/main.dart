import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:mind_games/widgets/home_screen/home_screen_widget.dart';
import 'package:mind_games/widgets/matrix_input_screen_widget.dart';
import 'package:mind_games/widgets/result_screens/maximin_screen_widget.dart';
import 'package:mind_games/widgets/result_screens/nash_balance_screen_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameProvider(rows: 2, cols: 2),
        ),
      ],
      child: GameTheoryApp(),
    ),
  );
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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo.shade300,
      ),
      themeMode: context.watch<GameProvider>().isDarkThemeActivated
          ? ThemeMode.dark
          : ThemeMode.light,
      routes: {
        "/home": (context) => HomeScreen(),
        "inputScreen": (context) => MatrixInputScreen(),
        "/home/maximin": (context) => MaximinScreenWidget(),
        "/home/nash_balance": (context) => NashBalanceScreenWidget(),
      },
      home: MatrixInputScreen(),
    );
  }
}
