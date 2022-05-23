// import 'dart:convert';
// import 'dart:io';
//
// import 'package:epub_viewer/epub_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() async {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool loading = false;
//   String filePath = "";
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: loading
//               ? CircularProgressIndicator()
//               : FlatButton(
//             onPressed: () async {
//               Directory appDocDir =
//               await getApplicationDocumentsDirectory();
//               print('$appDocDir');
//
//               String iosBookPath = 'assets/New-Findings-on-Shirdi-Sai-Baba (1).epub';
//               print(iosBookPath);
//               String androidBookPath = 'assets/New-Findings-on-Shirdi-Sai-Baba (1).epub';
//               EpubViewer.setConfig(
//                   themeColor: Theme.of(context).primaryColor,
//                   identifier: "iosBook",
//                   scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
//                   allowSharing: true,
//                   enableTts: true,
//                   nightMode: true);
//
//               // get current locator
//               EpubViewer.locatorStream.listen((locator) {
//                 print(
//                     'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
//               });
//
//               EpubViewer.open(
//                 filePath,
//                 lastLocation: EpubLocator.fromJson({
//                   "bookId": "2239",
//                   "href": "/OEBPS/ch06.xhtml",
//                   "created": 1539934158390,
//                   "locations": {
//                     "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//                   }
//                 }),
//               );
//
//               // await EpubViewer.openAsset(
//               //   'assets/4.epub',
//               //   lastLocation: EpubLocator.fromJson({
//               //     "bookId": "2239",
//               //     "href": "/OEBPS/ch06.xhtml",
//               //     "created": 1539934158390,
//               //     "locations": {
//               //       "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//               //     }
//               //   }),
//               // );
//             },
//             child: Container(
//               child: Text('open epub'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }