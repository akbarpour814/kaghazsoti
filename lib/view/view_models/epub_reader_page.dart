//------/dart and flutter packages
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:epub_view/epub_view.dart';
import 'package:internet_file/internet_file.dart';

//------/controller
import '/controller/custom_dio.dart';
import '/controller/custom_response.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '/model/category.dart';

//------/view/pages/category_page
import '/view/pages/category_page/subcategories_page.dart';

//------/view/view_models
import '/view/view_models/category_name.dart';
import '/view/view_models/custom_circular_progress_indicator.dart';
import '/view/view_models/no_internet_connection.dart';

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

  Future _initCategories() async {
    Uint8List _data = await InternetFile.get(widget.path);

    _epubController = EpubController(document: EpubDocument.openData(_data,),);


    setState(() {
      dataIsLoading = false;
    });


    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
      drawer: dataIsLoading ? FutureBuilder(
        future: _initCategories(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return  Drawer(
            child: EpubViewTableOfContents(controller: _epubController),
          );
        },
      ) : Drawer(
        child: EpubViewTableOfContents(controller: _epubController),
      ),
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
        future: _initCategories(),
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
