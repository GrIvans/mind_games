import 'package:flutter/material.dart';
import 'package:mind_games/data/game_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> {
  void _setTheme(bool status) {
    setState(() {
      context.read<GameProvider>().setDarkThemeStatus(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Настройки",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Темный режим",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Switch(
                  value: gameProvider.isDarkThemeActivated,
                  onChanged: _setTheme)
            ],
          )
        ],
      ),
    );
  }
}
