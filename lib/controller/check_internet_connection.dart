import 'dart:io';

bool internetIsConnected = false;

Future checkInternetConnection() async {
  final result = await InternetAddress.lookup('https://kaghazsoti.com/');

  try {


    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      internetIsConnected = true;
    }

    print('connected');
  } on SocketException catch (_) {
    print('not connected');
  }

  return result;
}