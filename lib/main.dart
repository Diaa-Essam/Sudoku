import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(SudokuAIApp());
}

class SudokuAIApp extends StatelessWidget {
  const SudokuAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sudoku AI Solver",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const Scaffold(body: Center(child: Text('Hello Sudoku'))),
    );
  }
}
