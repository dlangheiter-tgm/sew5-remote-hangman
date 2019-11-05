import 'dart:convert';

import 'dart:io';

class Scoreboard {
  final File file;
  List<_ScoreboardEntry> entries;

  Scoreboard(String path) : file = File(path) {
    if(!file.existsSync()) {
      file.createSync();
      entries = List();
      _save();
    } else {
      List<dynamic> rawJson = jsonDecode(file.readAsStringSync());
      entries = rawJson.map((json) => _ScoreboardEntry.fromJson(json)).toList();
      print(entries);
    }
  }
  
  _save() {
    file.writeAsStringSync(jsonEncode(entries.map((e) => e.toJson()).toList()));
  }
}

class _ScoreboardEntry {
  final int tries;
  final String name;
  final String word;

  _ScoreboardEntry({this.tries, this.name, this.word});

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

  Map<String, dynamic> toJson() {
    return {
      'tries': tries,
      'name': name,
      'word': word,
    };
  }
}
