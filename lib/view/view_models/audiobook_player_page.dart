import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaghaze_souti/view/audio_player_models/next_button.dart';
import 'package:kaghaze_souti/view/audio_player_models/play_button.dart';
import 'package:kaghaze_souti/view/audio_player_models/previous_button.dart';
import '../audio_player_models/audio_player_handler.dart';
import '../audio_player_models/common.dart';
import '/model/book_introduction.dart';
import '/main.dart';
import '/model/book.dart';
import '/view/view_models/book_introduction_page.dart';
import '/view/view_models/progress_bar/custom_progress_bar.dart';
import '/view/view_models/progress_bar/playOrPauseController.dart';
import 'package:sizer/sizer.dart';

import '../../controller/custom_dio.dart';
import 'custom_circular_progress_indicator.dart';

List<Part> parts = [];
class AudiobookPlayerPage extends StatefulWidget {
  late BookIntroduction audiobook;

  AudiobookPlayerPage({
    Key? key,
    required this.audiobook,
  }) : super(key: key);

  @override
  _AudiobookPlayerPageState createState() => _AudiobookPlayerPageState();
}

class _AudiobookPlayerPageState extends State<AudiobookPlayerPage> {
  late Response<dynamic> _customDio;

  late List<MediaItem> _mediaItems;
  late  bool _internetConnectionChecker;

  @override
  void initState() {
    _mediaItems = [];

    super.initState();
  }
 
  
  
  Future _initMediaItems() async {
     _customDio = await CustomDio.dio.post('dashboard/books/${widget.audiobook.slug}/audio');

    if (_customDio.statusCode == 200) {
      setState(() {
        for (Map<String, dynamic> mediaItem in _customDio.data['data']) {
          _mediaItems.add( MediaItem(
            id: 'https://kaghazsoti.uage.ir/storage/book-files/${mediaItem['url']}',
            album: widget.audiobook.name,
            title: mediaItem['name'] ?? '',
            artist: widget.audiobook.author,
            duration: Duration(milliseconds: DateFormat('HH:mm:ss').parse(mediaItem['timer'], true).millisecondsSinceEpoch),
            artUri: Uri.parse(
                widget.audiobook.bookCoverPath),
          ),
          );
        }
        print(_mediaItems.length);
        print('_mediaItems.length');
      });

      audioPlayerHandler.updateQueue(_mediaItems);
    }

    return _customDio;
  }

  // void _setAudioSource() async{
  //   audioPlayerHandler =  await AudioService.init(
  //     builder: () => AudioPlayerHandlerImplements(),
  //     config: const AudioServiceConfig(
  //       androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //       androidNotificationChannelName: 'Audio playback',
  //       androidNotificationOngoing: true,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const Divider(
        height: 0.0,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.audiobook.name),
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          setState(() {


            Navigator.of(context).pop();
          });
        },
        child: const Icon(
          Ionicons.chevron_down_outline,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            setState(() {

              audiobookInPlayId = -1;
              audioIsPlaying.$ = false;
              audioPlayerHandler.updateQueue([]);
              audioPlayerHandler.stop();
              audioPlayerHandler.onTaskRemoved();
              audioPlayerHandler.seek(Duration(microseconds: 0));

              Navigator.of(context).pop();
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.close_outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {

    //return _innerBody();
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
      },
      future: _initMediaItems(),
    );

    // if((parts.isEmpty) || (previousAudiobookInPlayId != audiobookInPlay!.id) || (demoIsPlaying.of(context))) {
    //   return FutureBuilder(
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       return snapshot.hasData
    //           ? _innerBody()
    //           : const Center(child: CustomCircularProgressIndicator());
    //     },
    //     future: _initMediaItems(),
    //   );
    // } else {
    //   if(!audioIsPlaying.of(context)) {
    //     _setAudioSource();
    //   }
    //
    //   return _innerBody();
    // }
  }

  Widget _innerBody() {
    Column _body = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 5.0.w,
            top: 16.0,
            right: 5.0.w,
            bottom: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bookCover(),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("name"),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        _buttons(),
                      ],
                    ),
                  ),
                ],
              ),
              _progressBar(),
              Text(
                'فهرست کتاب',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Divider(
            height: 0.0,
          ),
        ),
        _bookIndex(),
      ],
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return SingleChildScrollView(child: _body);
    } else {
      return _body;
    }
  }

  Flexible _bookCover() {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return BookIntroductionPage(bookIntroduction: widget.audiobook);
            },
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            shape: BoxShape.rectangle,
          ),
          width: 40.0.w,
          height: 20.0.h,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: defaultBookCover,
              image: widget.audiobook.bookCoverPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Row _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _nextButton(),
        _playOrPauseButton(),
        _previousButton(),
      ],
    );
  }

  Widget _nextButton() {
    return NextButton(audioPlayerHandler: audioPlayerHandler);
    // return StreamBuilder<SequenceState?>(
    //   stream: audioPlayer.sequenceStateStream,
    //   builder: (context, snapshot) => Flexible(
    //     child: InkWell(
    //       onTap: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
    //       child: Icon(
    //         Ionicons.play_forward_outline,
    //         color: audioPlayer.hasNext
    //             ? Theme.of(context).primaryColor
    //             : Colors.grey,
    //       ),
    //     ),
    //   ),
    // );
  }

  Flexible _playOrPauseButton() {
    return Flexible(
      /*child: PlayOrPauseController(
        audioPlayer: audioPlayer,
        playerBottomNavigationBar: false,
      ),*/
      child: PlayButton(audioPlayerHandler: audioPlayerHandler),
    );
  }

  Widget _previousButton() {
    return PreviousButton(audioPlayerHandler: audioPlayerHandler);
    // return StreamBuilder<SequenceState?>(
    //   stream: audioPlayer.sequenceStateStream,
    //   builder: (context, snapshot) => Flexible(
    //     child: InkWell(
    //       onTap: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
    //       child: Icon(
    //         Ionicons.play_back_outline,
    //         color: audioPlayer.hasPrevious
    //             ? Theme.of(context).primaryColor
    //             : Colors.grey,
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _progressBar() {
    // return StreamBuilder<PositionData>(
    //   stream: _positionDataStream,
    //   builder: (context, snapshot) {
    //     final positionData = snapshot.data ??
    //         PositionData(Duration.zero, Duration.zero, Duration.zero);
    //     return SeekBar(
    //       duration: positionData.duration,
    //       position: positionData.position,
    //       onChangeEnd: (newPosition) {
    //         audioPlayerHandler.seek(newPosition);
    //       },
    //     );
    //   },
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      /*child: CustomProgressBar(
        audioPlayer: audioPlayer,
        timeLabelLocation: TimeLabelLocation.below,
        baseBarColor: const Color(0xFFC6DADE).withOpacity(0.4),
        progressBarColor: const Color(0xFF005C6B),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF005C6B),
        thumbGlowColor: const Color(0xFF005C6B).withOpacity(0.6),
      ),*/
      child: Text('PRO'),
    );
  }

  Widget _bookIndex() {
    Column _bookIndex = Column(
      children: List<Card>.generate(
        parts.length,
        (index) {
          Part _part = parts[index];

          return Card(
            color: Colors.transparent,
            elevation: 0.0,
            shape: Theme.of(context).cardTheme.shape,
            child: ListTile(
              title: Text(_part.name),
              subtitle: Text(_part.time),
              //-----------------------------------------------------------------------------------------------
              trailing: index == 0
                  ? const Icon(Ionicons.download_outline)
                  : null,
            ),
          );
        },
      ),
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _bookIndex;
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: _bookIndex,
        ),
      );
    }
  }
}
