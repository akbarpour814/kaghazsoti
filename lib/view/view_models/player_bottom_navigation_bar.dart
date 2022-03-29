import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/view_models/progress_bar/custom_progress_bar.dart';
import 'package:takfood_seller/view/view_models/progress_bar/playOrPauseController.dart';
import 'package:sizer/sizer.dart';

import 'audiobook_player_page.dart';

class PlayerBottomNavigationBar extends StatefulWidget {
  const PlayerBottomNavigationBar({Key? key,}) : super(key: key);

  @override
  _PlayerBottomNavigationBarState createState() =>
      _PlayerBottomNavigationBarState();
}

class _PlayerBottomNavigationBarState extends State<PlayerBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    if (playing.of(context)) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        color: const Color(0xFF005C6B),
        width: 100.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            demoIsPlaying.of(context) ? _stopDemoPlayer(): _navigatorToAudiobookPlayerPage(context),
            _progressBar(),
            _playOrPauseButton(),
          ],
        ),
      );
    } else {
      return const Divider(
        height: 0.0,
        thickness: 1.0,
      );
    }
  }

  Flexible _stopDemoPlayer() {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            player.stop();

            playing.$ = false;
            demoIsPlaying.$ = false;

            audiobookInPlayId = -1;
          });
        },
        child: const Icon(
          Ionicons.close_outline,
          color: Colors.white,
        ),
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
                return const AudiobookPlayerPage();
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

  SizedBox _progressBar() {
    return SizedBox(
      width: 75.0.w,
      child: CustomProgressBar(
        audioPlayer: demoIsPlaying.of(context) ? demoPlayer : audioPlayer,
        timeLabelLocation: TimeLabelLocation.none,
        baseBarColor: Colors.white,
        progressBarColor: const Color(0xFF55929C),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF55929C),
        thumbGlowColor: const Color(0xFF55929C).withOpacity(0.6),
      ),
    );
  }

  Flexible _playOrPauseButton() {
    return Flexible(
      child: PlayOrPauseController(audioPlayer: player, playerBottomNavigationBar: true,),
    );
  }
}
