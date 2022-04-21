// import 'dart:async';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:kaghaze_souti/view/view_models/book_introduction_page.dart';
// import 'package:kaghaze_souti/view/view_models/custom_circular_progress_indicator.dart';
// import 'package:kaghaze_souti/view/view_models/no_internet_connection.dart';
// import 'package:sizer/sizer.dart';
//
// import 'controller/custom_dio.dart';
// import 'controller/internet_connection.dart';
// import 'controller/load_data_from_api.dart';
// import 'main.dart';
// import 'model/book_introduction.dart';
// import 'dart:async';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//
// late AssetsAudioPlayer assetsAudioPlayer;
//
// class MyApp_2 extends StatefulWidget {
//   late List<Audio> audios;
//   late BookIntroduction audiobook;
//
//   MyApp_2({
//     Key? key,
//     required this.audios,
//     required this.audiobook,
//   }) : super(key: key);
//
//   @override
//   _MyApp_2State createState() => _MyApp_2State();
// }
//
// class _MyApp_2State extends State<MyApp_2>
//     with InternetConnection, LoadDataFromAPI {
//
//   final List<StreamSubscription> _subscriptions = [];
//   late List<Audio> audios = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     dataIsLoading = widget.audiobook.id != previousAudiobookInPlayId;
//
//     audiobookIsPlaying.$ = true;
//
//     assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
//
//     _subscriptions.add(assetsAudioPlayer.playlistAudioFinished.listen((data) {
//       print('playlistAudioFinished : $data');
//     }));
//
//     _subscriptions.add(assetsAudioPlayer.audioSessionId.listen((sessionId) {
//       print('audioSessionId : $sessionId');
//     }));
//   }
//
//   Future _initMediaItems() async {
//     customDio = await CustomDio.dio
//         .post('dashboard/books/${widget.audiobook.slug}/audio');
//
//     if (customDio.statusCode == 200) {
//       if (widget.audiobook.id != previousAudiobookInPlayId) {
//         setState(() {
//           for (Map<String, dynamic> mediaItem in customDio.data['data']) {
//             audios.add(
//               Audio.network(
//                 'https://kaghazsoti.uage.ir/storage/book-files/${mediaItem['url']}',
//                 metas: Metas(
//                   id: 'Online',
//                   title: mediaItem['name'] ?? '',
//                   artist: widget.audiobook.author,
//                   album: widget.audiobook.name,
//                   // image: MetasImage.network('https://www.google.com')
//                   image: MetasImage.asset('assets/images/defaultBookCover.jpg'),
//                 ),
//               ),
//             );
//           }
//
//           previousAudiobookInPlayId = widget.audiobook.id;
//
//           dataIsLoading = false;
//         });
//
//         openPlayer();
//       }
//     }
//
//     return customDio;
//   }
//
//   bool x = false;
//
//   void openPlayer() async {
//     await assetsAudioPlayer.open(
//       Playlist(audios: audios, startIndex: 0),
//       showNotification: true,
//       autoStart: true,
//     );
//   }
//
//   @override
//   void dispose() {
//    if(x) {
//      assetsAudioPlayer.dispose();
//      print('dispose');
//      super.dispose();
//    }
//   }
//
//   Audio find(List<Audio> source, String fromPath) {
//     return source.firstWhere((element) => element.path == fromPath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),
//       body: _body(),
//       bottomNavigationBar: const Divider(
//         height: 0.0,
//       ),
//     );
//   }
//
//   Widget _body() {
//     if ((dataIsLoading) && (widget.audiobook.id != previousAudiobookInPlayId)) {
//       return FutureBuilder(
//         future: _initMediaItems(),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.hasData && x) {
//             return _innerBody();
//           } else {
//             return Center(child: CustomCircularProgressIndicator());
//           }
//         },
//       );
//     } else {
//       if (demoOfBookIsPlaying.of(context)) {
//         return _innerBody();
//       } else {
//         return FutureBuilder(
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             return _innerBody();
//           },
//           future: assetsAudioPlayer.play(),
//         );
//       }
//     }
//   }
//
//   Widget _innerBody() {
//     Widget _body = Column(
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _upperPart(),
//             //_bookIntroduction(),
//             _progressBar(),
//             //_cycleModesAndSpeedPlay(),
//             _lowerPart(),
//           ],
//         ),
//         _bookIndex(),
//       ],
//     );
//
//     if (connectionStatus == ConnectivityResult.none) {
//       assetsAudioPlayer.stop();
//
//       setState(() {
//         dataIsLoading = true;
//       });
//
//       return const Center(
//         child: NoInternetConnection(),
//       );
//     } else {
//       if (MediaQuery.of(context).orientation == Orientation.landscape) {
//         return SingleChildScrollView(child: _body);
//       } else {
//         return _body;
//       }
//     }
//   }
//
//   AppBar _appBar() {
//     return AppBar(
//       title: Text(widget.audiobook.name),
//       automaticallyImplyLeading: false,
//       leading: InkWell(
//         onTap: () {
//           setState(() {
//             Navigator.of(context).pop();
//           });
//         },
//         child: const Icon(
//           Ionicons.chevron_down_outline,
//         ),
//       ),
//       actions: [
//         InkWell(
//           onTap: () {
//             setState(() {
//               x = true;
//               audiobookInPlayId = -1;
//               audiobookIsPlaying.$ = false;
//
//               previousAudiobookInPlayId = -1;
//               Navigator.of(context).pop();
//             });
//           },
//           child: const Padding(
//             padding: EdgeInsets.all(18.0),
//             child: Icon(
//               Ionicons.close_outline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Padding _upperPart() {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 5.0.w,
//         top: 16.0,
//         right: 5.0.w,
//         bottom: 0.0,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _bookCover(),
//           Expanded(
//             child: _controlButtons(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   InkWell _bookCover() {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) {
//             return BookIntroductionPage(book: widget.audiobook);
//           },
//         ));
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Theme.of(context).primaryColor),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(5.0),
//           ),
//           shape: BoxShape.rectangle,
//         ),
//         width: 40.0.w,
//         height: 20.0.h,
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(
//             Radius.circular(5.0),
//           ),
//           child: FadeInImage.assetNetwork(
//             placeholder: defaultBookCover,
//             image: widget.audiobook.bookCoverPath,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
//
//   PlayerBuilder _controlButtons() {
//     return assetsAudioPlayer.builderCurrent(
//         builder: (context, Playing? playing) {
//       return Column(
//         children: <Widget>[
//           assetsAudioPlayer.builderLoopMode(
//             builder: (context, loopMode) {
//               return PlayerBuilder.isPlaying(
//                   player: assetsAudioPlayer,
//                   builder: (context, isPlaying) {
//                     return PlayingControls(
//                       loopMode: loopMode,
//                       isPlaying: isPlaying,
//                       isPlaylist: true,
//                       onStop: () {
//                         assetsAudioPlayer.stop();
//                       },
//                       toggleLoop: () {
//                         assetsAudioPlayer.toggleLoop();
//                       },
//                       onPlay: () {
//                         assetsAudioPlayer.playOrPause();
//                       },
//                       onNext: () {
//                         //_assetsAudioPlayer.forward(Duration(seconds: 10));
//                         assetsAudioPlayer.next(
//                             keepLoopMode: true /*keepLoopMode: false*/);
//                       },
//                       onPrevious: () {
//                         assetsAudioPlayer.previous(/*keepLoopMode: false*/);
//                       },
//                     );
//                   });
//             },
//           ),
//         ],
//       );
//     });
//   }
//
//   PlayerBuilder _progressBar() {
//     return assetsAudioPlayer.builderRealtimePlayingInfos(
//         builder: (context, RealtimePlayingInfos? infos) {
//       if (infos == null) {
//         return SizedBox();
//       }
//       return PositionSeekWidget(
//         playerBottomNavigationBar: false,
//         currentPosition: infos.currentPosition,
//         duration: infos.duration,
//         seekTo: (to) {
//           assetsAudioPlayer.seek(to);
//         },
//       );
//     });
//   }
//
//   Column _lowerPart() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//             left: 5.0.w,
//             top: 0.0,
//             right: 5.0.w,
//             bottom: 8.0,
//           ),
//           child: Text(
//             'فهرست کتاب',
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         ),
//         Divider(
//           height: 0.0,
//         ),
//       ],
//     );
//   }
//
//   Widget _bookIndex() {
//     SingleChildScrollView _bookIndex = SingleChildScrollView(child:
//         assetsAudioPlayer.builderCurrent(
//             builder: (BuildContext context, Playing? playing) {
//       return SongsSelector(
//         audios: audios,
//         onPlaylistSelected: (myAudios) {
//           assetsAudioPlayer.open(
//             Playlist(audios: myAudios),
//             showNotification: true,
//             headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
//             audioFocusStrategy:
//                 AudioFocusStrategy.request(resumeAfterInterruption: true),
//           );
//         },
//         onSelected: (myAudio) async {
//           try {
//             await assetsAudioPlayer.open(
//               myAudio,
//               autoStart: true,
//               showNotification: true,
//               playInBackground: PlayInBackground.enabled,
//               audioFocusStrategy: AudioFocusStrategy.request(
//                   resumeAfterInterruption: true,
//                   resumeOthersPlayersAfterDone: true),
//               headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//               notificationSettings: NotificationSettings(
//                 seekBarEnabled: false,
//                 stopEnabled: true,
//                 customStopAction: (player) {
//                   player.stop();
//                 },
//                 prevEnabled: false,
//                 customNextAction: (player) {
//                   print('next');
//                 },
//                 customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
//                 customPauseIcon: AndroidResDrawable(name: 'ic_pause_custom'),
//                 customPlayIcon: AndroidResDrawable(name: 'ic_play_custom'),
//               ),
//             );
//           } catch (e) {
//             print(e);
//           }
//         },
//         playing: playing,
//         duration: Duration(),
//       );
//     }));
//
//     if (MediaQuery.of(context).orientation == Orientation.landscape) {
//       return _bookIndex;
//     } else {
//       return Expanded(
//         child: _bookIndex,
//       );
//     }
//   }
// }
//
// class PlayingControls extends StatelessWidget {
//   final bool isPlaying;
//   final LoopMode? loopMode;
//   final bool isPlaylist;
//   final Function()? onPrevious;
//   final Function() onPlay;
//   final Function()? onNext;
//   final Function()? toggleLoop;
//   final Function()? onStop;
//
//   PlayingControls({
//     required this.isPlaying,
//     this.isPlaylist = false,
//     this.loopMode,
//     this.toggleLoop,
//     this.onPrevious,
//     required this.onPlay,
//     this.onNext,
//     this.onStop,
//   });
//
//   Widget _loopIcon(BuildContext context) {
//     final iconSize = 34.0;
//     if (loopMode == LoopMode.none) {
//       return Icon(
//         Icons.loop,
//         size: iconSize,
//         color: Colors.grey,
//       );
//     } else if (loopMode == LoopMode.playlist) {
//       return Icon(
//         Icons.loop,
//         size: iconSize,
//         color: Colors.black,
//       );
//     } else {
//       //single
//       return Stack(
//         alignment: Alignment.center,
//         children: [
//           Icon(
//             Icons.loop,
//             size: iconSize,
//             color: Colors.black,
//           ),
//           Center(
//             child: Text(
//               '1',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _nextButton(context),
//         _playButton(context),
//         _previousButton(context),
//       ],
//     );
//   }
//
//   InkWell _nextButton(BuildContext context) {
//     return InkWell(
//       child: Icon(
//         Ionicons.play_forward_outline,
//         color: isPlaylist ? Theme.of(context).primaryColor : Colors.grey,
//       ),
//       onTap: isPlaylist ? onNext : null,
//     );
//   }
//
//   Widget _playButton(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: onPlay,
//       child: Icon(
//         isPlaying ? Ionicons.pause_outline : Ionicons.play_outline,
//       ),
//     );
//   }
//
//   InkWell _previousButton(BuildContext context) {
//     return InkWell(
//       child: Icon(
//         Ionicons.play_back_outline,
//         color: isPlaylist ? Theme.of(context).primaryColor : Colors.grey,
//       ),
//       onTap: isPlaylist ? onPrevious : null,
//     );
//   }
// }
//
// class PositionSeekWidget extends StatefulWidget {
//   final bool playerBottomNavigationBar;
//   final Duration currentPosition;
//   final Duration duration;
//   final Function(Duration) seekTo;
//
//   const PositionSeekWidget({
//     required this.playerBottomNavigationBar,
//     required this.currentPosition,
//     required this.duration,
//     required this.seekTo,
//   });
//
//   @override
//   _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
// }
//
// class _PositionSeekWidgetState extends State<PositionSeekWidget> {
//   late Duration _visibleValue;
//   bool listenOnlyUserInterraction = false;
//
//   double get percent => widget.duration.inMilliseconds == 0
//       ? 0
//       : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;
//
//   @override
//   void initState() {
//     super.initState();
//     _visibleValue = widget.currentPosition;
//   }
//
//   @override
//   void didUpdateWidget(PositionSeekWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!listenOnlyUserInterraction) {
//       _visibleValue = widget.currentPosition;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Slider(
//         thumbColor: Colors.blue,
//         activeColor: Colors.red,
//         inactiveColor: Colors.yellow,
//         min: 0,
//         max: widget.duration.inMilliseconds.toDouble(),
//         value: percent * widget.duration.inMilliseconds.toDouble(),
//         onChangeEnd: (newValue) {
//           setState(() {
//             listenOnlyUserInterraction = false;
//             widget.seekTo(_visibleValue);
//           });
//         },
//         onChangeStart: (_) {
//           setState(() {
//             listenOnlyUserInterraction = true;
//           });
//         },
//         onChanged: (newValue) {
//           setState(() {
//             final to = Duration(milliseconds: newValue.floor());
//             _visibleValue = to;
//           });
//         },
//       ),
//     );
//   }
// }
//
// String durationToString(Duration duration) {
//   String twoDigits(int n) {
//     if (n >= 10) return '$n';
//     return '0$n';
//   }
//
//   final twoDigitMinutes =
//       twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
//   final twoDigitSeconds =
//       twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
//   return '$twoDigitMinutes:$twoDigitSeconds';
// }
//
// class SongsSelector extends StatelessWidget {
//   final Playing? playing;
//   final List<Audio> audios;
//   final Function(Audio) onSelected;
//   final Function(List<Audio>) onPlaylistSelected;
//   final Duration duration;
//
//   SongsSelector(
//       {required this.playing,
//       required this.audios,
//       required this.onSelected,
//       required this.onPlaylistSelected,
//       required this.duration});
//
//   Widget _image(Audio item) {
//     if (item.metas.image == null) {
//       return SizedBox(height: 40, width: 40);
//     }
//
//     return item.metas.image?.type == ImageType.network
//         ? Image.network(
//             item.metas.image!.path,
//             height: 40,
//             width: 40,
//             fit: BoxFit.cover,
//           )
//         : Image.asset(
//             item.metas.image!.path,
//             height: 40,
//             width: 40,
//             fit: BoxFit.cover,
//           );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Flexible(
//           child: ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, position) {
//               final item = audios[position];
//               final isPlaying = item.path == playing?.audio.assetAudioPath;
//
//               return Card(
//                 elevation: 0.0,
//                 shape: Theme.of(context).cardTheme.shape,
//                 color: isPlaying ? Theme.of(context).primaryColor : null,
//                 child: ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           item.metas.title.toString(),
//                           style: TextStyle(
//                             color: isPlaying ? Colors.white : null,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         durationToString(duration),
//                         style: Theme.of(context).textTheme.caption,
//                       ),
//                     ],
//                   ),
//                   onTap: () => onSelected(item),
//                 ),
//               );
//             },
//             itemCount: audios.length,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class VolumeSelector extends StatelessWidget {
//   final double volume;
//   final Function(double) onChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Volume ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: NeumorphicSlider(
//               min: AssetsAudioPlayer.minVolume,
//               max: AssetsAudioPlayer.maxVolume,
//               value: volume,
//               style:
//                   SliderStyle(variant: Colors.grey, accent: Colors.grey[500]),
//               onChanged: (value) {
//                 onChange(value);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   const VolumeSelector({
//     required this.volume,
//     required this.onChange,
//   });
// }
//
// class ForwardRewindSelector extends StatelessWidget {
//   final double speed;
//   final Function(double) onChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Wrap(
//         crossAxisAlignment: WrapCrossAlignment.center,
//         children: <Widget>[
//           Text(
//             'Forward/Rewind ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           _button(-2),
//           _button(2.0),
//         ],
//       ),
//     );
//   }
//
//   Widget _button(double value) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: NeumorphicRadio(
//         groupValue: speed,
//         padding: EdgeInsets.all(12.0),
//         value: value,
//         style: NeumorphicRadioStyle(
//           boxShape: NeumorphicBoxShape.circle(),
//         ),
//         onChanged: (double? v) {
//           if (v != null) onChange(v);
//         },
//         child: Text('x$value'),
//       ),
//     );
//   }
//
//   const ForwardRewindSelector({
//     required this.speed,
//     required this.onChange,
//   });
// }
//
// class PlaySpeedSelector extends StatelessWidget {
//   final double playSpeed;
//   final Function(double) onChange;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Wrap(
//         crossAxisAlignment: WrapCrossAlignment.center,
//         children: <Widget>[
//           Text(
//             'PlaySpeed ',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           _button(0.5),
//           _button(1.0),
//           _button(2.0),
//           _button(4.0),
//         ],
//       ),
//     );
//   }
//
//   Widget _button(double value) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: NeumorphicRadio(
//         groupValue: playSpeed,
//         padding: EdgeInsets.all(12.0),
//         value: value,
//         style: NeumorphicRadioStyle(
//           boxShape: NeumorphicBoxShape.circle(),
//         ),
//         onChanged: (double? v) {
//           if (v != null) onChange(v);
//         },
//         child: Text('x$value'),
//       ),
//     );
//   }
//
//   const PlaySpeedSelector({
//     required this.playSpeed,
//     required this.onChange,
//   });
// }
//
// class PlayingControlsSmall extends StatelessWidget {
//   final bool isPlaying;
//   final LoopMode loopMode;
//   final Function() onPlay;
//   final Function()? onStop;
//   final Function()? toggleLoop;
//
//   PlayingControlsSmall({
//     required this.isPlaying,
//     required this.loopMode,
//     this.toggleLoop,
//     required this.onPlay,
//     this.onStop,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         NeumorphicRadio(
//           style: NeumorphicRadioStyle(
//             boxShape: NeumorphicBoxShape.circle(),
//           ),
//           padding: EdgeInsets.all(12),
//           value: LoopMode.playlist,
//           groupValue: loopMode,
//           onChanged: (newValue) {
//             if (toggleLoop != null) toggleLoop!();
//           },
//           child: Icon(
//             Icons.loop,
//             size: 18,
//           ),
//         ),
//         SizedBox(
//           width: 12,
//         ),
//         NeumorphicButton(
//           style: NeumorphicStyle(
//             boxShape: NeumorphicBoxShape.circle(),
//           ),
//           padding: EdgeInsets.all(16),
//           onPressed: onPlay,
//           child: Icon(
//             isPlaying ? Icons.pause : Icons.play_arrow,
//             size: 32,
//           ),
//         ),
//         if (onStop != null)
//           NeumorphicButton(
//             style: NeumorphicStyle(
//               boxShape: NeumorphicBoxShape.circle(),
//             ),
//             padding: EdgeInsets.all(16),
//             onPressed: onPlay,
//             child: Icon(
//               Icons.stop,
//               size: 32,
//             ),
//           ),
//       ],
//     );
//   }
// }
//
// class MyAudio {
//   final Audio audio;
//   final String name;
//   final String imageUrl;
//
//   const MyAudio({
//     required this.audio,
//     required this.name,
//     required this.imageUrl,
//   });
// }
