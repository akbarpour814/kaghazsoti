import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takfood_seller/view/view_models/progress_bar/progress_bar_state.dart';
import 'package:takfood_seller/view/view_models/progress_bar/progress_notifier.dart';

import '../../../main.dart';

class CustomProgressBar extends StatefulWidget {
  late AudioPlayer audioPlayer;
  late TimeLabelLocation timeLabelLocation;
  late Color baseBarColor;
  late Color progressBarColor;
  late Color bufferedBarColor;
  late Color thumbColor;
  late Color thumbGlowColor;

  CustomProgressBar({
    Key? key,
    required this.audioPlayer,
    required this.timeLabelLocation,
    required this.baseBarColor,
    required this.progressBarColor,
    required this.bufferedBarColor,
    required this.thumbColor,
    required this.thumbGlowColor,
  }) : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  final ProgressNotifier _progressNotifier = ProgressNotifier();

  void seek(Duration position) {
    widget.audioPlayer.seek(position);
  }

  void _listenForChangesInPlayerPosition() {
    widget.audioPlayer.positionStream.listen((position) {
      final ProgressBarState oldState = _progressNotifier.value;
      _progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInBufferedPosition() {
    widget.audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final ProgressBarState oldState = _progressNotifier.value;
      _progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInTotalDuration() {
    widget.audioPlayer.durationStream.listen((totalDuration) {
      final ProgressBarState oldState = _progressNotifier.value;
      _progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  @override
  void initState() {
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          // progress: Duration(milliseconds: 1000),
          // buffered: Duration(milliseconds: 2000),
          // total: Duration(milliseconds: 5000),
          onSeek: seek,
          timeLabelLocation: widget.timeLabelLocation,
          baseBarColor: widget.baseBarColor,
          progressBarColor: widget.progressBarColor,
          bufferedBarColor: widget.bufferedBarColor,
          thumbColor: widget.thumbColor,
          thumbGlowColor: widget.thumbGlowColor,
          thumbGlowRadius: 20.0,
        );
      },
    );
  }

 /*Widget _buildWidgetContainerControlAudioPlayer(MediaQueryData mediaQuery) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: mediaQuery.size.height / 11.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (_, __) {
                  return _buildWidgetOfPreviousButton();
                },
              ),
              StreamBuilder<PlayerState>(
                stream: audioPlayer.playerStateStream,
                builder: (_, snapshot) {
                  final PlayerState? playerState = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: _buildWidgetOfPlayOrPauseButton(playerState),
                        ),
                      ),
                    ],
                  );
                },
              ),
              StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (_, __) {
                  return _buildWidgetOfNextButton();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          Visibility(
            visible: _connectionStatus == ConnectivityResult.none,
            child: const Text(
              'لطفاً از اتصال شبکه اینترنت خود مطمئن شوید',
              style: TextStyle(
                color: Color(0xFF7D9AFF),
                fontSize: 30.0,
                fontFamily: 'Narenj',
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }

  IconButton _buildWidgetOfPreviousButton() {
    return IconButton(
      onPressed: () async {
        if (indexOfAudioPlayed != 0) {
          setState(() {
            indexOfAudioPlayed--;
          });

          audioPlayer.setUrl(currentSection!.audios[indexOfAudioPlayed].path);
          audioPlayer.play();
        }
      },
      icon: Icon(
        Icons.fast_rewind,
        color: ((indexOfAudioPlayed != 0) ? Colors.black : Colors.grey),
      ),
    );
  }

  Widget _buildWidgetOfPlayOrPauseButton(PlayerState? playerState) {
    late final ProcessingState processingState;

    if (playerState != null) {
      processingState = playerState.processingState;

      if (_connectionStatus == ConnectivityResult.none) {
        return IconButton(
          icon: const Icon(Icons.wifi_off),
          iconSize: 44.0,
          onPressed: audioPlayer.stop,
        );
      } else if ((processingState == ProcessingState.loading) && loading) {
        return IconButton(
          icon: const Icon(Icons.sync),
          iconSize: 44.0,
          onPressed: audioPlayer.play,
        );
      } else if (audioPlayer.playing != true &&
          processingState != ProcessingState.completed) {
        tempPlaylistOfTheCurrentSectionIsFinished =
            playlistOfTheCurrentSectionIsFinished;
        playlistOfTheCurrentSectionIsFinished = false;

        return IconButton(
            icon: Icon(tempPlaylistOfTheCurrentSectionIsFinished!
                ? Icons.repeat
                : Icons.play_arrow),
            iconSize: 44.0,
            onPressed: audioPlayer.play);
      } else if (processingState != ProcessingState.completed) {
        return IconButton(
          icon: const Icon(Icons.pause),
          iconSize: 44.0,
          onPressed: audioPlayer.pause,
        );
      } else if (processingState == ProcessingState.completed &&
          indexOfAudioPlayed != currentSection!.numberOfAudios - 1) {
      } else {
        playlistOfTheCurrentSectionIsFinished = true;
      }
    }

    return IconButton(
      icon: const Icon(Icons.pause),
      iconSize: 44.0,
      onPressed: audioPlayer.play,
    );
  }

  IconButton _buildWidgetOfNextButton() {
    return IconButton(
      onPressed: () async {
        if (indexOfAudioPlayed != currentSection!.numberOfAudios - 1) {
          setState(() {
            indexOfAudioPlayed++;
          });

          audioPlayer.setUrl(currentSection!.audios[indexOfAudioPlayed].path);
          audioPlayer.play();
        }
      },
      icon: Icon(
        Icons.fast_forward,
        color: ((indexOfAudioPlayed != currentSection!.numberOfAudios - 1)
            ? Colors.black
            : Colors.grey),
      ),
    );
  }*/
}
