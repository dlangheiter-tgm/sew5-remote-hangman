import 'dart:convert';
import 'dart:io';

class Hangman {
  final String word;
  int remainingTries;
  String maskedWord;
  bool _finished = false;

  Hangman(this.word, [this.remainingTries = 11])
      : maskedWord = '_' * word.length;

  static Future<Hangman> fromFile() async {
    // src: https://stackoverflow.com/questions/21813401/reading-file-line-by-line-in-dart
    final words = await File("res/words.txt")
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .toList();

    return Hangman((words..shuffle()).first);
  }

  guess(String _in) {
    _in = _in.toUpperCase();
    if (_in.length == 1) {
      bool foundChar = false;
      for (int i = 0; i < word.length; i++) {
        if (word[i].toUpperCase() == _in) {
          maskedWord = _replaceCharAt(maskedWord, i, word[i]);
          foundChar = true;
        }
      }
      if (!foundChar) {
        remainingTries--;
      }
    } else {
      if (_in == word.toUpperCase()) {
        maskedWord = word;
        _finished = true;
      } else {
        remainingTries--;
      }
    }
  }

  bool isFinished() {
    return _finished || remainingTries < 1;
  }

  String endMessage() {
    if (remainingTries < 1) {
      return "You lose. The word was $word";
    } else {
      return "You win.";
    }
  }

  String _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  @override
  String toString() {
    return "${remainingTries} 1 remaining trie${remainingTries == 1 ? '' : 's'}. ${maskedWord}";
  }
}
