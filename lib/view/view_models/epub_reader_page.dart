//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:epub_view/epub_view.dart';
import 'package:internet_file/internet_file.dart';

//------/controller
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/view/view_models
import '/view/view_models/custom_circular_progress_indicator.dart';

//------/main
import '/main.dart';

// ignore: must_be_immutable
class EpubReaderPage extends StatefulWidget {
  late String path;
  EpubReaderPage({Key? key, required this.path,}) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage>
    with InternetConnection, LoadDataFromAPI {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();
  }

  Future _initEpub() async {
    Uint8List _data = await InternetFile.get(widget.path);

    _epubController = EpubController(document: EpubDocument.openData(_data,),);

    dataIsLoading = false;

    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.chevron_back_outline,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initEpub(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(
              child: CustomCircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return _innerBody();
    }
  }

  EpubView _innerBody() {
    return EpubView(
      builders: EpubViewBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        chapterDividerBuilder: (_) => const Divider(),
      ),
      controller: _epubController,
    );
  }
}
