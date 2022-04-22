import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import '../audio_player_models/audiobook_player_page.dart';
import '../audio_player_models/show_slider_dialog.dart';
import '../audio_player_models/progress_bar/custom_progress_bar.dart';
import '/main.dart';
import 'package:sizer/sizer.dart';

import 'package:rxdart/rxdart.dart';

class PlayerBottomNavigationBar extends StatefulWidget {
  const PlayerBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _PlayerBottomNavigationBarState createState() =>
      _PlayerBottomNavigationBarState();
}

class _PlayerBottomNavigationBarState extends State<PlayerBottomNavigationBar> with InternetConnection {
  @override
  Widget build(BuildContext context) {
    if(connectionStatus == ConnectivityResult.none) {
      if (demoOfBookIsPlaying.of(context)) {
        return FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return _notPlaying();
          },
          future: demoPlayer.stop(),
        );
      } else if (audiobookIsPlaying.of(context)) {
        return FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return _notPlaying();
          },
          future: audioPlayerHandler.stop(),
        );
      } else {
        return _notPlaying();
      }
    } else {
      if (demoOfBookIsPlaying.of(context)) {
        return _demoOfBookIsPlaying(context);
      } else if (audiobookIsPlaying.of(context)) {
        return _audiobookIsPlaying(context);
      } else {
        return _notPlaying();
      }
    }
  }

  Container _demoOfBookIsPlaying(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      width: 100.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _closeButtonForDemoOfBook(),
          _progressBarForDemoOfBook(),
          _playButtonForDemoOfBook(),
        ],
      ),
    );
  }

  Flexible _closeButtonForDemoOfBook() {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            demoOfBookIsPlaying.$ = false;
            demoInPlayId = -1;
            demoPlayer.stop();
          });
        },
        child: const Icon(
          Ionicons.close_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox _progressBarForDemoOfBook() {
    return SizedBox(
      width: 75.0.w,
      child: CustomProgressBar(
        audioPlayer: demoPlayer,
        timeLabelLocation: TimeLabelLocation.none,
        baseBarColor: Colors.white,
        progressBarColor: const Color(0xFF55929C),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF55929C),
        thumbGlowColor: const Color(0xFF55929C).withOpacity(0.6),
      ),
    );
  }

  Flexible _playButtonForDemoOfBook() {
    return Flexible(
      child: StreamBuilder<PlayerState>(
        stream: demoPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            print('11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');

            return InkWell(
              onTap: null,
              child: const Icon(
                Ionicons.refresh_outline,
                color: Colors.white,
              ),
            );
          } else if (playing != true) {
            print('22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222');
            print(playing);

            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.play,
            );
          } else if(processingState == ProcessingState.completed) {
            print('33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333');

            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.play,
            );
          } else {
            print('4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444');

            return InkWell(
              child: const Icon(
                Ionicons.pause_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.pause,
            );
          }
        },
      ),
    );
  }

  Container _audiobookIsPlaying(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      width: 100.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _navigatorToAudiobookPlayerPage(context),
          _progressBarForAudiobook(),
          _playButtonForAudiobook(),
        ],
      ),
    );
  }

  Flexible _navigatorToAudiobookPlayerPage(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AudiobookPlayerPage(
                  audiobook: audiobookInPlay,
                );
              },
            ),
          );
        },
        child: const Icon(
          Ionicons.chevron_up_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox _progressBarForAudiobook() {
    return SizedBox(
      width: 75.0.w,
      child: CustomProgressBarBottom(
        audioPlayer: audioPlayerHandler.audioPlayer,
        timeLabelLocation: TimeLabelLocation.none,
        baseBarColor: Colors.white,
        progressBarColor: const Color(0xFF55929C),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF55929C),
        thumbGlowColor: const Color(0xFF55929C).withOpacity(0.6),
      ),
    );
  }

  Flexible _playButtonForAudiobook() {
    return Flexible(
      child: StreamBuilder<PlaybackState>(
        stream: audioPlayerHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          final playing = playbackState?.playing;
          if (processingState == AudioProcessingState.loading ||
              processingState == AudioProcessingState.buffering) {
            return InkWell(
              onTap: null,
              child: const Icon(
                Ionicons.refresh_outline,
                color: Colors.white,
              ),
            );
          } else if (playing != true) {
            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: audioPlayerHandler.play,
            );
          } else {
            return InkWell(
              child: const Icon(
                Ionicons.pause_outline,
                color: Colors.white,
              ),
              onTap: audioPlayerHandler.pause,
            );
          }
        },
      ),
    );
  }

  Divider _notPlaying() {
    return const Divider(
      height: 0.0,
    );
  }
}

/*
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart' as JustAudio;
import 'package:kaghaze_souti/controller/internet_connection.dart';
import '../../test.dart';
import '../audio_player_models/audiobook_player_page.dart';
import '../audio_player_models/audiobook_player_page_2.dart';
import '../audio_player_models/audiobook_player_page_3.dart';
import '../audio_player_models/show_slider_dialog.dart';
import '../audio_player_models/progress_bar/custom_progress_bar.dart';
import '/main.dart';
import 'package:sizer/sizer.dart';

import 'package:rxdart/rxdart.dart';

class PlayerBottomNavigationBar extends StatefulWidget {
  const PlayerBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _PlayerBottomNavigationBarState createState() =>
      _PlayerBottomNavigationBarState();
}

class _PlayerBottomNavigationBarState extends State<PlayerBottomNavigationBar> with InternetConnection {
  @override
  Widget build(BuildContext context) {
    if(connectionStatus == ConnectivityResult.none) {
      if (demoOfBookIsPlaying.of(context)) {
        return FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return _notPlaying();
          },
          future: demoPlayer.stop(),
        );
      } else if (audiobookIsPlaying.of(context) && assetsAudioPlayer != null) {
        return FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return _notPlaying();
          },
          future: assetsAudioPlayer!.play(),
        );
      } else {
        return _notPlaying();
      }
    } else {
      if (demoOfBookIsPlaying.of(context)) {
        return _demoOfBookIsPlaying(context);
      } else if (audiobookIsPlaying.of(context)) {
        return _audiobookIsPlaying(context);
      } else {
        return _notPlaying();
      }
    }
  }

  Container _demoOfBookIsPlaying(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      width: 100.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _closeButtonForDemoOfBook(),
          _progressBarForDemoOfBook(),
          _playButtonForDemoOfBook(),
        ],
      ),
    );
  }

  Flexible _closeButtonForDemoOfBook() {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            demoOfBookIsPlaying.$ = false;
            demoInPlayId = -1;
            demoPlayer.stop();
          });
        },
        child: const Icon(
          Ionicons.close_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox _progressBarForDemoOfBook() {
    return SizedBox(
      width: 75.0.w,
      child: CustomProgressBar(
        audioPlayer: demoPlayer,
        timeLabelLocation: TimeLabelLocation.none,
        baseBarColor: Colors.white,
        progressBarColor: const Color(0xFF55929C),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF55929C),
        thumbGlowColor: const Color(0xFF55929C).withOpacity(0.6),
      ),
    );
  }

  Flexible _playButtonForDemoOfBook() {
    return Flexible(
      child: StreamBuilder<JustAudio.PlayerState>(
        stream: demoPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;

          if (processingState == JustAudio.ProcessingState.loading ||
              processingState == JustAudio.ProcessingState.buffering) {
            return InkWell(
              onTap: null,
              child: const Icon(
                Ionicons.refresh_outline,
                color: Colors.white,
              ),
            );
          } else if (playing != true) {
            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.play,
            );
          } else if(processingState == JustAudio.ProcessingState.completed) {
            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.play,
            );
          } else {
            return InkWell(
              child: const Icon(
                Ionicons.pause_outline,
                color: Colors.white,
              ),
              onTap: demoPlayer.pause,
            );
          }
        },
      ),
    );
  }



  Container _audiobookIsPlaying(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).primaryColor,
      width: 100.0.w,
      height: 5.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _navigatorToAudiobookPlayerPage(context),
          _progressBarForAudiobook(),
          _playButtonForAudiobook(),
        ],
      ),
    );
  }

  Flexible _navigatorToAudiobookPlayerPage(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AudiobookPlayerPage_3(
                  audiobook: audiobookInPlay,
                );
              },
            ),
          );
        },
        child: const Icon(
          Ionicons.chevron_up_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox _progressBarForAudiobook() {
    return SizedBox(
      width: 75.0.w,
      child: assetsAudioPlayer!.builderRealtimePlayingInfos(
          builder: (context, RealtimePlayingInfos? infos) {
            if (infos == null) {
              return SizedBox();
            }
            return PositionSeekWidget(
              playerBottomNavigationBar: true,
              currentPosition: infos.currentPosition,
              duration: infos.duration,
              seekTo: (to) {
                assetsAudioPlayer!.seek(to);
              },
            );
          }),
    );

    // return SizedBox(
    //   width: 75.0.w,
    //   child: CustomProgressBarBottom(
    //     audioPlayer: audioPlayerHandler.audioPlayer,
    //     timeLabelLocation: TimeLabelLocation.none,
    //     baseBarColor: Colors.white,
    //     progressBarColor: const Color(0xFF55929C),
    //     bufferedBarColor: const Color(0xFFC6DADE),
    //     thumbColor: const Color(0xFF55929C),
    //     thumbGlowColor: const Color(0xFF55929C).withOpacity(0.6),
    //   ),
    // );
  }

  Widget _playButtonForAudiobook() {
    return Flexible(
      child: PlayerBuilder.isPlaying(player: assetsAudioPlayer!, builder: (BuildContext context, bool isPlaying) {
        return InkWell(
          onTap: () {
            assetsAudioPlayer!.playOrPause();
          },
          child: Icon(
            isPlaying ? Ionicons.pause_outline : Ionicons.play_outline,
            color: Colors.white,
          ),);
      },),

    );
    return Flexible(
      child: StreamBuilder<PlaybackState>(
        stream: audioPlayerHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          final playing = playbackState?.playing;
          if (processingState == AudioProcessingState.loading ||
              processingState == AudioProcessingState.buffering) {
            return InkWell(
              onTap: null,
              child: const Icon(
                Ionicons.refresh_outline,
                color: Colors.white,
              ),
            );
          } else if (playing != true) {
            return InkWell(
              child: const Icon(
                Ionicons.play_outline,
                color: Colors.white,
              ),
              onTap: audioPlayerHandler.play,
            );
          } else {
            return InkWell(
              child: const Icon(
                Ionicons.pause_outline,
                color: Colors.white,
              ),
              onTap: audioPlayerHandler.pause,
            );
          }
        },
      ),
    );
  }

  Divider _notPlaying() {
    return const Divider(
      height: 0.0,
    );
  }
}
*/
