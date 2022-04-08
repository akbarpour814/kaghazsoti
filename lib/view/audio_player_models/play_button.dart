import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'audio_player_handler.dart';

class PlayButton extends StatefulWidget {
  late AudioPlayerHandler audioPlayerHandler;

  PlayButton({Key? key, required this.audioPlayerHandler,}) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  late Widget _playIcon;
  late Function()? _playFunction;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: widget.audioPlayerHandler.playbackState,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final processingState = playbackState?.processingState;
        final playing = playbackState?.playing;

        if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
          _playIcon = const CircularProgressIndicator(color: Colors.white,);

          _playFunction = null;

          return FloatingActionButton(onPressed: null, child: _playIcon,);
        } else if (playing != true) {
          _playIcon = const Icon(Ionicons.play_outline, color: Colors.white,);

          _playFunction = widget.audioPlayerHandler.play;

          return FloatingActionButton(onPressed: widget.audioPlayerHandler.play, child: _playIcon,);
        }
        else {
          _playIcon = const Icon(Ionicons.pause_outline, color: Colors.white,);

          _playFunction = widget.audioPlayerHandler.pause;

          return FloatingActionButton(onPressed: widget.audioPlayerHandler.pause, child: _playIcon,);
        }

        return FloatingActionButton(onPressed: _playFunction, child: _playIcon,);
      },
    );
  }
}
