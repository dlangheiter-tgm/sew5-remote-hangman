import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'dart:typed_data';

class Client {
  final String host;
  final int port;

  Client(this.host, this.port);

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

  void _handleServer(Uint8List data) {
    String _in = String.fromCharCodes(data);
    if (_in.trim().isEmpty) {
      return;
    }
    print(_in.trim());
  }
}
