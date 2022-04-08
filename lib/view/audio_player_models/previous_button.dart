import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '/view/audio_player_models/queue_state.dart';
import 'audio_player_handler.dart';

class PreviousButton extends StatefulWidget {
  late AudioPlayerHandler audioPlayerHandler;

  PreviousButton({Key? key, required this.audioPlayerHandler,}) : super(key: key);

  @override
  _PreviousButtonState createState() => _PreviousButtonState();
}

class _PreviousButtonState extends State<PreviousButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: widget.audioPlayerHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        return InkWell(
          onTap: queueState.hasPrevious ? widget.audioPlayerHandler.skipToPrevious : null,
          child: Icon(
            Ionicons.play_back_outline,
            color: queueState.hasPrevious
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        );
      },
    );
  }
}
