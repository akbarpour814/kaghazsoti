//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'dart:async';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';


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
class PdfReaderPage extends StatefulWidget {
  late String path;
  PdfReaderPage({Key? key, required this.path,}) : super(key: key);

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage>
    with InternetConnection, LoadDataFromAPI {
  late PDFDocument _pdfDocument;

  @override
  void initState() {
    super.initState();
  }

  Future _initCategories() async {
    _pdfDocument = await PDFDocument.fromURL(widget.path);

    return _pdfDocument;
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
      title: const Text('پی دی اف'),
      leading: const Icon(
        Ionicons.albums_outline,
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
      future: _initCategories(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        } else {
          if (connectionStatus == ConnectivityResult.none) {
            return const Center(
              child: NoInternetConnection(),
            );
          } else {
            return _innerBody();
          }
        }
      },
    );
  }

  PDFViewer _innerBody() {
    return PDFViewer(
      document: _pdfDocument,
      zoomSteps: 1,
      //uncomment below line to preload all pages
      // lazyLoad: false,
      // uncomment below line to scroll vertically
      // scrollDirection: Axis.vertical,

      //uncomment below code to replace bottom navigation with your own
      /* navigationBuilder:
                          (context, page, totalPages, jumpToPage, animateToPage) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () {
                                jumpToPage()(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        );
                      }, */
    );
  }
}
