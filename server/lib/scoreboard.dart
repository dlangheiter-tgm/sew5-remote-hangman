import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:synchronized/synchronized.dart';

/// Class to manage the scoreboard
class Scoreboard {
  final lock;
  final File file;
  List<_ScoreboardEntry> entries;

  /// Constructor. Uses the [path] to the file.
  ///
  /// If the [file] exists reads it, else creates it
  Scoreboard(String path)
      : file = File(path),
        lock = Lock() {
    if (!file.existsSync()) {
      file.createSync();
      entries = List();
      _save();
    } else {
      List<dynamic> rawJson = jsonDecode(file.readAsStringSync());
      entries = rawJson.map((json) => _ScoreboardEntry.fromJson(json)).toList();
    }
  }

  /// Adds an entry to the scoreboard
  ///
  /// Adds the entry to the list with the [tries], the [name] and the [word]
  addEntry(int tries, String name, String word) {
    entries.add(_ScoreboardEntry(
      tries: tries,
      name: name,
      word: word,
    ));
    _save();
  }

  /// Saves the current scoreboard list to the file
  _save() async {
    entries.sort((a, b) => b.tries.compareTo(a.tries));
    entries = entries.sublist(0, min(entries.length, 10));
    await lock.synchronized(() async {
      await file
          .writeAsString(jsonEncode(entries.map((e) => e.toJson()).toList()));
    });
  }
}

/// Class to store the scoreboard entries
class _ScoreboardEntry {
  final int tries;
  final String name;
  final String word;

  _ScoreboardEntry({this.tries, this.name, this.word});

  /// Factory to create a [ScoreboardEntry] from json ([Map<String, dynamic>])
  factory _ScoreboardEntry.fromJson(Map<String, dynamic> json) {
    return _ScoreboardEntry(
      tries: json['tries'],
      name: json['name'],
      word: json['word'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ScoreboardEntry &&
          runtimeType == other.runtimeType &&
          tries == other.tries &&
          name == other.name &&
          word == other.word;

  @override
  int get hashCode => tries.hashCode ^ name.hashCode ^ word.hashCode;

  /// Converts to json ([Map<String, dynamic>])
  Map<String, dynamic> toJson() {
    return {
      'tries': tries,
      'name': name,
      'word': word,
    };
  }

  @override
  String toString() {
    return '_ScoreboardEntry{tries: $tries, name: $name, word: $word}';
  }
}
