import 'package:client/client.dart' as client;

// Main method for Client
main(List<String> arguments) async {
  if(arguments.length != 2) {
    print("Usage: client <host> <port>");
    return;
  }
  final c = client.Client(arguments[0], int.parse(arguments[1]));
  await c.run();
}
