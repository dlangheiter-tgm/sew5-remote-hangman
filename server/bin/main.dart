import 'package:server/server.dart' as server;

main(List<String> arguments) async {
  await server.Server(int.parse(arguments.first)).run();
}
