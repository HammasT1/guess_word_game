import 'dart:math';

class WordManager {
  final List<String> _wordList = ['SHIP', 'BOAT', 'CANO', 'RAFT'];
  String _currentWord = '';
  List<String> _displayWord = [];

  String get currentWord => _currentWord;
  List<String> get displayWord => _displayWord;

  void newWord() {
    _currentWord = _wordList[Random().nextInt(_wordList.length)];
    _displayWord = List.filled(_currentWord.length, '_');
  }

  bool checkGuess(String guess) {
    bool correct = false;
    for (int i = 0; i < _currentWord.length; i++) {
      if (_currentWord[i] == guess) {
        _displayWord[i] = guess;
        correct = true;
      }
    }
    return _displayWord.join() == _currentWord;
  }

  void showHint() {
    int hiddenIndex = _displayWord.indexOf('_');
    if (hiddenIndex != -1) {
      _displayWord[hiddenIndex] = _currentWord[hiddenIndex];
    }
  }
}