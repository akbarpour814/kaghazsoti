import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takfood_seller/main.dart';

class PlayOrPauseController extends StatefulWidget {
  late AudioPlayer audioPlayer;
  late bool playerBottomNavigationBar;
  late bool demoIsPlaying;

  PlayOrPauseController({Key? key, required this.audioPlayer, required this.playerBottomNavigationBar, required this.demoIsPlaying,}) : super(key: key);

  @override
  _PlayOrPauseControllerState createState() => _PlayOrPauseControllerState();
}

class _PlayOrPauseControllerState extends State<PlayOrPauseController> {
  late Widget playOrPauseIcon;
  late Function()? playOrPauseFunction;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
          playOrPauseIcon = widget.playerBottomNavigationBar ? const Icon(Ionicons.reload_outline, color: Colors.white,) : const CircularProgressIndicator(color: Colors.white,);
          playOrPauseFunction = null;
        } else if (playing != true) {
          playOrPauseIcon = const Icon(Ionicons.play_outline, color: Colors.white,);
          playOrPauseFunction = widget.audioPlayer.play;
        } else if (processingState != ProcessingState.completed) {
          audioIsPlaying.$ = true;
          
          playOrPauseIcon = const Icon(Ionicons.pause_outline, color: Colors.white,);
          playOrPauseFunction = widget.audioPlayer.pause;
        } else {
          playOrPauseIcon = const Icon(Ionicons.refresh_outline, color: Colors.white,);
          playOrPauseFunction = () => widget.audioPlayer.seek(Duration.zero, index: widget.audioPlayer.effectiveIndices!.first);
        }

        if(widget.playerBottomNavigationBar) {
          return InkWell(
            onTap: playOrPauseFunction,
            child: playOrPauseIcon,
          );
        } else {
          return FloatingActionButton(
            onPressed: playOrPauseFunction,
            child: playOrPauseIcon,
          );
        }
      },
    );
  }
}
