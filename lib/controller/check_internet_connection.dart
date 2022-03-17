// import 'dart:io';
//
// late bool internetIsConnected;
//
// Future<Stream<bool>> checkInternetConnection() async {
//   while(true) {
//     try {
//       final result = await InternetAddress.lookup('example.com');
//
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         internetIsConnected = true;
//
//         yield internetIsConnected;
//       }
//     } on SocketException catch (_) {
//       print('not connected');
//     }
//   }
// }