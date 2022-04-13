

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as INTL;
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/view/audio_player_models/audio_player_handler.dart';
import 'package:kaghaze_souti/view/audio_player_models/queue_state.dart';
import 'package:kaghaze_souti/view/view_models/book_introduction_page.dart';
import 'package:kaghaze_souti/view/view_models/custom_circular_progress_indicator.dart';
import 'package:kaghaze_souti/view/view_models/progress_bar/custom_progress_bar.dart';
import 'package:sizer/sizer.dart';

import '../../controller/custom_dio.dart';
import '../../main.dart';
import '../../model/book_introduction.dart';
import '../view_models/no_internet_connection.dart';
import 'common.dart';

import 'package:rxdart/rxdart.dart';

class AudiobookPlayerPage extends StatefulWidget {
  late BookIntroduction audiobook;

  AudiobookPlayerPage({
    Key? key,
    required this.audiobook,
  }) : super(key: key);

  @override
  State<AudiobookPlayerPage> createState() => _AudiobookPlayerPageState();
}

List<MediaItem> mediaItems = [];
class _AudiobookPlayerPageState extends State<AudiobookPlayerPage> {



  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  late bool _dataIsLoading;
  late Response<dynamic> _customDio;


  Stream<Duration> get _bufferedPositionStream =>
      audioPlayerHandler.playbackState
          .map((state) => state.bufferedPosition)
          .distinct();

  Stream<Duration?> get _durationStream =>
      audioPlayerHandler.mediaItem.map((item) => item?.duration).distinct();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    _dataIsLoading = widget.audiobook.id != previousAudiobookInPlayId;

    audioIsPlaying.$ = true;

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initMediaItems() async {
    _customDio = await CustomDio.dio
        .post('dashboard/books/${widget.audiobook.slug}/audio');

    if (_customDio.statusCode == 200) {
      if(widget.audiobook.id != previousAudiobookInPlayId) {
        setState(() {
          for (Map<String, dynamic> mediaItem in _customDio.data['data']) {
            mediaItems.add(
              MediaItem(
                id: 'https://kaghazsoti.uage.ir/storage/book-files/${mediaItem['url']}',
                album: widget.audiobook.name,
                title: mediaItem['name'] ?? '',
                artist: widget.audiobook.author,
                duration: Duration(
                    milliseconds: INTL.DateFormat('HH:mm:ss')
                        .parse(mediaItem['timer'], true)
                        .millisecondsSinceEpoch),
                artUri: Uri.parse(widget.audiobook.bookCoverPath),
              ),
            );
          }


          audioPlayerHandler.updateQueue(mediaItems);

          _dataIsLoading = false;

          previousAudiobookInPlayId = widget.audiobook.id;

        });


      }
    }

    return _customDio;
  }

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
              previousAudiobookInPlayId = -1;
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
    return _dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : Center(child: CustomCircularProgressIndicator(message: 'لطفاً شکیبا باشید.'));
              },
            future: _initMediaItems(),
          )
        : _innerBody();
  }

  Widget _innerBody() {

    Widget _body = Column(
      children: [
        SizedBox(
          height: 40.0.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 5.0.w,
                  top: 16.0,
                  right: 5.0.w,
                  bottom: 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _bookCover(),
                    Expanded(
                      child: StreamBuilder<MediaItem?>(
                        stream: audioPlayerHandler.mediaItem,
                        builder: (context, snapshot) {
                          final mediaItem = snapshot.data;
                          if (mediaItem == null) return const SizedBox();
                          return SizedBox(
                            height: 20.0.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(mediaItem.album ?? '', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                               /* SizedBox(
                                  height: 4.0.h,
                                ),*/
                                Text(mediaItem.title, textAlign: TextAlign.center,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    StreamBuilder<QueueState>(
                                      stream: audioPlayerHandler.queueState,
                                      builder: (context, snapshot) {
                                        final queueState = snapshot.data ?? QueueState.empty;
                                        return InkWell(
                                          child: Icon(Ionicons.play_forward_outline,
                                            color: queueState.hasNext
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                          ),
                                          onTap: queueState.hasNext ? audioPlayerHandler.skipToNext : null,
                                        );
                                      },
                                    ),

                                    StreamBuilder<PlaybackState>(
                                      stream: audioPlayerHandler.playbackState,
                                      builder: (context, snapshot) {
                                        final playbackState = snapshot.data;
                                        final processingState = playbackState?.processingState;
                                        final playing = playbackState?.playing;
                                        if (processingState == AudioProcessingState.loading ||
                                            processingState == AudioProcessingState.buffering) {
                                          return FloatingActionButton(
                                            onPressed: null,
                                            child: const CircularProgressIndicator(color: Colors.white,),
                                          );
                                        } else if (playing != true) {

                                          return FloatingActionButton(
                                            child: const Icon(Ionicons.play_outline),
                                            onPressed: () {
                                              setState(() {
                                                demoPlayer.stop();
                                                demoIsPlaying.$ = false;
                                                demoInPlayId = -1;
                                              });


                                              audioPlayerHandler.play();
                                            },
                                          );
                                        } else {
                                          return FloatingActionButton(
                                            child: const Icon(Ionicons.pause_outline),
                                            onPressed: audioPlayerHandler.pause,
                                          );
                                        }
                                      },
                                    ),

                                    StreamBuilder<QueueState>(
                                      stream: audioPlayerHandler.queueState,
                                      builder: (context, snapshot) {
                                        final queueState = snapshot.data ?? QueueState.empty;
                                        return InkWell(
                                          child: Icon(Ionicons.play_back_outline,
                                            color: queueState.hasPrevious
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,),
                                          onTap:
                                          queueState.hasPrevious ? audioPlayerHandler.skipToPrevious : null,
                                        );
                                      },
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: CustomProgressBar(audioPlayer: audioPlayerHandler.audioPlayer, timeLabelLocation: TimeLabelLocation.below, baseBarColor: Colors.grey.shade300,),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<AudioServiceRepeatMode>(
                      stream: audioPlayerHandler.playbackState
                          .map((state) => state.repeatMode)
                          .distinct(),
                      builder: (context, snapshot) {
                        final repeatMode =
                            snapshot.data ?? AudioServiceRepeatMode.none;
                        List<Icon> icons = [
                          Icon(Icons.repeat, color: Colors.grey,),
                          Icon(Icons.repeat, color: Theme.of(context).primaryColor,),
                          Icon(Icons.repeat_one, color: Theme.of(context).primaryColor,),
                        ];
                        const cycleModes = [
                          AudioServiceRepeatMode.none,
                          AudioServiceRepeatMode.all,
                          AudioServiceRepeatMode.one,
                        ];
                        final index = cycleModes.indexOf(repeatMode);
                        return InkWell(
                          child: icons[index],
                          onTap: () {
                            audioPlayerHandler.setRepeatMode(cycleModes[
                            (cycleModes.indexOf(repeatMode) + 1) %
                                cycleModes.length]);
                          },
                        );
                      },
                    ),

                    StreamBuilder<double>(
                      stream: audioPlayerHandler.speed,
                      builder: (context, snapshot) => InkWell(
                        child: Text("${snapshot.data?.toStringAsFixed(1)}x", style: TextStyle(color: Theme.of(context).primaryColor)),
                        onTap: () {
                          showSliderDialog(
                            context: context,
                            title: 'سرعت پخش',
                            divisions: 10,
                            min: 0.5,
                            max: 1.5,
                            value: audioPlayerHandler.speed.value,
                            stream: audioPlayerHandler.speed,
                            onChanged: audioPlayerHandler.setSpeed,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: Text(
                  'فهرست کتاب',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Divider(
                height: 0.0,
              ),
            ],
          ),
        ),

        _bookIndex(),

      ],
    );


    if(_connectionStatus == ConnectivityResult.none) {
      audioPlayerHandler.stop();

      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        return SingleChildScrollView(child: _body);
      } else {
        return _body;
      }
    }

  }

  Widget _bookCover() {
    return InkWell(
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
    );
  }

  /*Row _buttons() {
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
      *//*child: PlayOrPauseController(
        audioPlayer: audioPlayer,
        playerBottomNavigationBar: false,
      ),*//*
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
  }*/

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
    Widget _bookIndex =  StreamBuilder<QueueState>(
      stream: audioPlayerHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;
        return SingleChildScrollView(
          child: Column(

            children: [
              for (var i = 0; i < queue.length; i++)
                Card(
                  elevation: 0.0,
                  shape: Theme.of(context).cardTheme.shape,
                  color: i == queueState.queueIndex
                      ? Theme.of(context).primaryColor
                      : null,
                  child: ListTile(
                    title: Text(queue[i].title, style: TextStyle(color: i == queueState.queueIndex ? Colors.white : null),),
                    subtitle: Text(queue[i].duration.toString()),
                    onTap: () => audioPlayerHandler.skipToQueueItem(i),
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _bookIndex;
    } else {
      return Expanded(
        child: _bookIndex,
      );
    }
  }

}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;

  const ControlButtons(this.audioHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        StreamBuilder<double>(
          stream: audioHandler.speed,
          builder: (context, snapshot) => InkWell(
            child: Text("${snapshot.data?.toStringAsFixed(1)}x", style: TextStyle(color: Theme.of(context).primaryColor)),
            onTap: () {
              showSliderDialog(
                context: context,
                title: 'سرعت پخش',
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: audioHandler.speed.value,
                stream: audioHandler.speed,
                onChanged: audioHandler.setSpeed,
              );
            },
          ),
        ),
        /*StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return InkWell(
              child: Icon(Ionicons.play_back_outline,
                  color: queueState.hasPrevious
                  ? Theme.of(context).primaryColor
                  : Colors.grey,),
              onTap:
              queueState.hasPrevious ? audioHandler.skipToPrevious : null,
            );
          },
        ),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playbackState = snapshot.data;
            final processingState = playbackState?.processingState;
            final playing = playbackState?.playing;
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering) {
              return FloatingActionButton(
               onPressed: null,
                child: const CircularProgressIndicator(color: Colors.white,),
              );
            } else if (playing != true) {
              return FloatingActionButton(
                child: const Icon(Ionicons.play_outline),
                onPressed: audioHandler.play,
              );
            } else {
              return FloatingActionButton(
                child: const Icon(Ionicons.pause_outline),
                onPressed: audioHandler.pause,
              );
            }
          },
        ),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return InkWell(
              child: Icon(Ionicons.play_forward_outline,
                color: queueState.hasNext
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onTap: queueState.hasNext ? audioHandler.skipToNext : null,
            );
          },
        ),*/

        StreamBuilder<AudioServiceRepeatMode>(
          stream: audioPlayerHandler.playbackState
              .map((state) => state.repeatMode)
              .distinct(),
          builder: (context, snapshot) {
            final repeatMode =
                snapshot.data ?? AudioServiceRepeatMode.none;
            const icons = [
              Icon(Icons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
            ];
            const cycleModes = [
              AudioServiceRepeatMode.none,
              AudioServiceRepeatMode.all,
              AudioServiceRepeatMode.one,
            ];
            final index = cycleModes.indexOf(repeatMode);
            return InkWell(
              child: icons[index],
              onTap: () {
                audioPlayerHandler.setRepeatMode(cycleModes[
                (cycleModes.indexOf(repeatMode) + 1) %
                    cycleModes.length]);
              },
            );
          },
        ),

        /*IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: audioHandler.volume.value,
              stream: audioHandler.volume,
              onChanged: audioHandler.setVolume,
            );
          },
        ),*/
      ],
    );
  }
}
