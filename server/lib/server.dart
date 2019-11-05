

import 'dart:io';

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
    print("New client accepted #$clientNum");
    await for(var req in client) {
      String _in = String.fromCharCodes(req);
      if(_in.trim().isEmpty) {
        continue;
      }
      print("Req: $_in");
      client.write("Hi\n");
    }
    print("Client disconnected");
  }

}