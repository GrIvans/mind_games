import 'package:flutter/material.dart';
import 'package:mind_games/data/matrix_provider.dart';
import 'package:mind_games/widgets/algorithm_card_widget.dart';
import 'package:mind_games/widgets/algorithm_result_screen_widget.dart';
import 'package:mind_games/widgets/matrix_input_screen_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final matrixProvider = Provider.of<MatrixProvider>(context);
    final List<List<num>> matrixA = matrixProvider.matrixA.list;
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlgorithmResultScreen(
                            algorithm: 'max-min',
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
