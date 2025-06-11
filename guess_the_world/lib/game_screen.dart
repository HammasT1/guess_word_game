import 'package:flutter/material.dart';
import 'dart:async';
import 'word_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final WordManager _wordManager = WordManager();
  final TextEditingController _controller = TextEditingController();
  String _input = '';
  int _attemptsLeft = 3;
  late AnimationController _controllerAnimation;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _wordManager.newWord();
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_controllerAnimation);
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _checkGuess() {
    setState(() {
      if (_wordManager.checkGuess(_input.toUpperCase())) {
        _showDialog('You Win!', 'Congratulations, you guessed the word!');
      } else {
        _attemptsLeft--;
        if (_attemptsLeft <= 0) {
          _showDialog('You Lose!', 'The word was ${_wordManager.currentWord}.');
        }
      }
    });
    _controller.clear();
    _triggerBounce();
  }

  void _showHint() {
    setState(() {
      _wordManager.showHint();
    });
    _triggerBounce();
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
        content: Text(message, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _wordManager.newWord();
                _attemptsLeft = 3;
              });
              Navigator.pop(context);
            },
            child: Text('Play Again', style: TextStyle(color: Colors.blue[700])),
          ),
        ],
      ),
    );
  }

  void _triggerBounce() {
    _controllerAnimation.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the Word', style: TextStyle(color: Colors.white, fontSize: 22)),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: Text(
                    'Attempts Left: $_attemptsLeft',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      shadows: [Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.blue[700]!.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _wordManager.displayWord.map((letter) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[700]!, width: 2),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4)],
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 30),
            AnimatedOpacity(
              opacity: _controller.text.isEmpty ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter a letter',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => setState(() => _input = value),
                textCapitalization: TextCapitalization.characters,
                maxLength: 1,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedOpacity(
                  opacity: _controller.text.isNotEmpty ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _controller.text.isNotEmpty ? _checkGuess : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Guess', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _wordManager.displayWord.contains('_') ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _wordManager.displayWord.contains('_') ? _showHint : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Hint', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}