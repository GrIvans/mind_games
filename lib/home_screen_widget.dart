import 'package:flutter/material.dart';
import 'package:mind_games/algorithm_card_widget.dart';
import 'package:mind_games/algorithm_result_screen_widget.dart';
import 'package:mind_games/matrix_input_screen_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<List<double>> matrixA = [];
    List<List<double>> matrixB = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Теоретико-игровая модель'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Карточка с информацией о текущей матрице
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Текущая матрица',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    matrixA.isNotEmpty
                        ? Text('Размер: ${matrixA.length}x${matrixA[0].length}')
                        : Text('Матрица не задана'),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () async {
                        (matrixA, matrixB) = await Navigator.push(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlgorithmResultScreen(
                            algorithm: 'max-min',
                            matrixA: matrixA,
                            matrixB: matrixB,
                          ),
                        ),
                      );
                    },
                  ),
                  AlgorithmCard(
                    title: 'Доминируемые стратегии',
                    icon: Icons.delete_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlgorithmResultScreen(
                            algorithm: 'dominated',
                            matrixA: matrixA,
                            matrixB: matrixB,
                          ),
                        ),
                      );
                    },
                  ),
                  AlgorithmCard(
                    title: 'Равновесия Нэша',
                    icon: Icons.balance,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlgorithmResultScreen(
                            algorithm: 'nash',
                            matrixA: matrixA,
                            matrixB: matrixB,
                          ),
                        ),
                      );
                    },
                  ),
                  AlgorithmCard(
                    title: 'Смешанные стратегии',
                    icon: Icons.shuffle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlgorithmResultScreen(
                            algorithm: 'mixed',
                            matrixA: matrixA,
                            matrixB: matrixB,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.history),
          //   label: 'История',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Навигация по вкладкам
        },
      ),
    );
  }
}
