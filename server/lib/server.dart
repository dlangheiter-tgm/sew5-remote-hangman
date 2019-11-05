import 'dart:io';

import 'package:server/hangman.dart';

class Server {
  final int port;
  int clientNum = 0;

  Server(this.port);

  run() async {
    final srv = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
    print("Serving at ${srv.address}:${srv.port}");
    srv.listen(handleClient);
  }

  void handleClient(Socket client) async {
    final num = clientNum++;
    print("New client accepted #$num}");
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
        break;
      }
      client.writeln(hm.toString());
    }

    print("Client disconnected #$num");
  }
}
