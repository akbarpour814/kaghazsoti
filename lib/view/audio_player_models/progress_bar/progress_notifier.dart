import 'package:flutter/cupertino.dart';
import 'package:kaghaze_souti/view/audio_player_models/progress_bar/progress_bar_state.dart';

class ProgressNotifier extends ValueNotifier<ProgressBarState> {
  ProgressNotifier() : super(_initialValue);
  static const ProgressBarState _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}