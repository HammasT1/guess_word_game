import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the Word',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}