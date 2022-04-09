import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaghaze_souti/main.dart';
import 'package:kaghaze_souti/model/book_introduction.dart';
import 'package:kaghaze_souti/view/view_models/audiobook_player_page.dart';
import 'package:kaghaze_souti/view/view_models/custom_circular_progress_indicator.dart';

import '../../../controller/custom_dio.dart';
import '../../audio_player_models/audio_player_handler.dart';

class BookChaptersPage extends StatefulWidget {
  late BookIntroduction book;

  BookChaptersPage({Key? key, required this.book,}) : super(key: key);

  @override
  _BookChaptersPageState createState() => _BookChaptersPageState();
}

class _BookChaptersPageState extends State<BookChaptersPage> {
  late Response<dynamic> _customDio;
  late List<MediaItem> _mediaItems;
  late  bool _internetConnectionChecker;

  @override
  void initState() {
    _mediaItems = [];

    super.initState();
  }

  Future _initMediaItems() async {
    _customDio = await CustomDio.dio.post('dashboard/books/${widget.book.slug}/audio');

    if (_customDio.statusCode == 200) {
      setState(() {
        _mediaItems.clear();

        for (Map<String, dynamic> mediaItem in _customDio.data['data']) {
          _mediaItems.add( MediaItem(
            id: 'https://kaghazsoti.uage.ir/storage/book-files/${mediaItem['url']}',
            album: widget.book.name,
            title: mediaItem['name'] ?? '',
            artist: widget.book.author,
            duration: Duration(milliseconds: DateFormat('HH:mm:ss').parse(mediaItem['timer'], true).millisecondsSinceEpoch),
            artUri: Uri.parse(
                widget.book.bookCoverPath),
          ),
          );
        }
      });
    }

    return _customDio;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { return snapshot.hasData ? SingleChildScrollView(
        child: Column(
          children: List.generate(_mediaItems.length, (index) =>
              InkWell(
                onTap: () {

                  // audioPlayerHandler.updateQueue(_mediaItems);
                  //
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       //return AudiobookPlayerPage(audiobook: widget.book);
                  //       return AudiobookPlayerPage(audiobook: widget.book, audioPlayerHandler: audioPlayerHandler);
                  //     },
                  //   ),
                  // );

                },
                child: Card(
            child: ListTile(
                title: Text(_mediaItems[index].title),
                subtitle: Text(_mediaItems[index].duration.toString()),
            ),
          ),
              ),),
        ),
      ): Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.')); }, future: _initMediaItems(),),
    );
  }
}
