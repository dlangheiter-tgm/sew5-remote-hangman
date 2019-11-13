import 'dart:convert';
import 'dart:io';

/// Class for the hangman logic
class Hangman {
  /// The word
  final String word;

  /// The remaining tries the user has left
  int remainingTries;

  /// The masked word to be displayed to the user
  String maskedWord;

  bool _finished = false;

  /// Creates hangman with given [word] and optional [remainingTries] (defaults to 11)
  Hangman(this.word, [this.remainingTries = 11])
      : maskedWord = '_' * word.length;

  /// Loads the words.txt file and selects a random word from that list
  static Future<Hangman> fromFile() async {
    // src: https://stackoverflow.com/questions/21813401/reading-file-line-by-line-in-dart
    final words = await File("res/words.txt")
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .toList();

    return Hangman((words..shuffle()).first);
  }

  /// Method to guess
  ///
  /// If [_in] is a letter make a letter guess. Else make a word guess.
  /// Letter and words are case insensitive
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

  /// Gets if the user has no tries left or guessed the word correctly
  bool isFinished() {
    return _finished || remainingTries < 1;
  }

  /// Get the message to send the user after it finished
  String endMessage() {
    if (remainingTries < 1) {
      return "You lose. The word was $word";
    } else {
      return "You win.";
    }
  }

  /// Replace a char in the given [string] at the [index] with the [newChar]
  String _replaceCharAt(String string, int index, String newChar) {
    return string.substring(0, index) +
        newChar +
        string.substring(index + 1);
  }

  @override
  String toString() {
    return "${remainingTries} 1 remaining trie${remainingTries == 1 ? '' : 's'}. ${maskedWord}";
  }
}
