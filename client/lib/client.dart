import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';


// Client class
class Client {
  final String host;
  final int port;

  /// Creates a client
  ///
  /// Connects to the server using the [host] and the [port]
  Client(this.host, this.port);

  /// Main run method
  ///
  /// Starts listening to the cli and connects to the server.
  /// Sends messages between cli and server
  void run() async {
    Stream<String> input =
        stdin.transform(utf8.decoder).transform(LineSplitter());

    Socket server = await Socket.connect(host, port);

    final in_sub = input.listen((line) {
      server.writeln(line.trim());
    });

    server.listen(_handleServer, onDone: () {
      server.close();
      in_sub.cancel();
    });
  }

  /// Handles messages from the server (aka print to cli)
  void _handleServer(Uint8List data) {
    String _in = String.fromCharCodes(data);
    if (_in.trim().isEmpty) {
      return;
    }
    print(_in.trim());
  }
}
