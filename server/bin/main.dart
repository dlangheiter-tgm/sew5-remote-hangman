import 'package:server/server.dart' as server;

main(List<String> arguments) async {
  if(arguments.length != 1) {
    print("Usage: server <host>");
    return;
  }
  await server.Server(int.parse(arguments.first)).run();
}
