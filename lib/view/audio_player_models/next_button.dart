import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'audio_player_handler.dart';
import 'queue_state.dart';

class NextButton extends StatefulWidget {
  late AudioPlayerHandler audioPlayerHandler;

  NextButton({Key? key, required this.audioPlayerHandler,}) : super(key: key);

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: widget.audioPlayerHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        return InkWell(
          onTap: queueState.hasNext ? widget.audioPlayerHandler.skipToNext : null,
          child: Icon(
            Ionicons.play_forward_outline,
            color: queueState.hasNext
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        );
      },
    );
  }
}
