import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:mind_games/widgets/home_screen/algorithm_card_widget.dart';
import 'package:mind_games/widgets/home_screen/settings_screen_widget.dart';
import 'package:mind_games/widgets/matrix_input_screen_widget.dart';
import 'package:mind_games/widgets/result_screens/maximin_screen_widget.dart';
import 'package:mind_games/widgets/result_screens/nash_balance_screen_widget.dart';
import 'package:mind_games/widgets/result_screens/nash_equilibrium_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void _changeScreen(int index) {
    setState(() {
      if (index != currentIndex) {
        currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final List<List<num>> matrixA = gameProvider.game.matrixA;
    return Scaffold(
      appBar: AppBar(
        title: Text('Теоретико-игровая модель'),
        centerTitle: true,
        leading: SizedBox(width: 1),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          MainTabWidget(matrixA: matrixA, gameProvider: gameProvider),
          SettingsScreenWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) => _changeScreen(index),
      ),
    );
  }
}

class MainTabWidget extends StatelessWidget {
  const MainTabWidget({
    super.key,
    required this.matrixA,
    required this.gameProvider,
  });

  final List<List<num>> matrixA;
  final GameProvider gameProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Текущая матрица',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  matrixA.isNotEmpty
                      ? Text('Размер: ${matrixA.length}x${matrixA[0].length}')
                      : Text('Матрица не задана'),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MatrixInputScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text('Изменить матрицу'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                AlgorithmCard(
                  title: 'Максимин/\nМинимакс',
                  icon: Icons.arrow_outward,
                  enabled: gameProvider.game.singleMatrixGame,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaximinScreenWidget(),
                      ),
                    );
                  },
                ),
                AlgorithmCard(
                  title: 'Равновесия Нэша',
                  icon: Icons.balance,
                  enabled: !gameProvider.game.singleMatrixGame,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NashBalanceScreenWidget(),
                      ),
                    );
                  },
                ),
                AlgorithmCard(
                  title: 'Равновесия Нэша в смешанных стратегиях',
                  icon: Icons.balance,
                  enabled: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NashEquilibriumScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
