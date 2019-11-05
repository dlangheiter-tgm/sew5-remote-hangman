import 'package:client/client.dart' as client;

main(List<String> arguments) {
  if(arguments.length != 2) {
    print("Usage: client <host> <port>");
    return;
  }
  client.Client(arguments[0], int.parse(arguments[1]));
}
