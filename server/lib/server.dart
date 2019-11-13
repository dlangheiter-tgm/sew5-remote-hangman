import 'dart:io';

import 'package:server/hangman.dart';
import 'package:server/scoreboard.dart';

/// Server class
class Server {
  final int port;
  int _clientNum = 0;
  Scoreboard _scoreboard;

  Server(this.port);

  /// Runs the server. Makes a scoreboard and starts listening to the [port]
  run() async {
    _scoreboard = Scoreboard("res/scoreboard.json");

    final srv = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    print("Serving at ${srv.address}:${srv.port}");
    srv.listen(handleClient);
  }

  /// Method to handle the client
  ///
  /// Loads a hangman from file. Sends msg back and forth until hangman finishes
  /// and then closes the connection.
  void handleClient(Socket client) async {
    final num = _clientNum++;
    print("New client accepted #$num");
    Hangman hm;

    try {
      hm = await Hangman.fromFile();
    } catch (e) {
      print("Exception: e");
      client.writeln("Could not read file.");
      await client.close();
      return;
    }

    client.writeln(hm.toString());
    await for (var req in client) {
      String _in = String.fromCharCodes(req);
      if (_in.trim().isEmpty) {
        continue;
      }
      hm.guess(_in);
      if (hm.isFinished()) {
        client.writeln(hm.endMessage());
        await client.close();
        _scoreboard.addEntry(
            hm.remainingTries, client.remoteAddress.host, hm.word);
        break;
      }
      client.writeln(hm.toString());
    }

    print("Client disconnected #$num");
  }
}
