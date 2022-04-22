// import 'dart:async';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audio_service/audio_service.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:intl/intl.dart' as INTL;
// import 'package:ionicons/ionicons.dart';
// import 'package:kaghaze_souti/controller/internet_connection.dart';
// import 'package:kaghaze_souti/controller/load_data_from_api.dart';
// import 'package:kaghaze_souti/view/audio_player_models/audio_player_handler.dart';
// import 'package:kaghaze_souti/view/audio_player_models/progress_bar/custom_progress_bar.dart';
// import 'package:kaghaze_souti/view/audio_player_models/queue_state.dart';
// import 'package:kaghaze_souti/view/view_models/book_introduction_page.dart';
// import 'package:kaghaze_souti/view/view_models/custom_circular_progress_indicator.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../controller/custom_dio.dart';
// import '../../main.dart';
// import '../../model/book_introduction.dart';
// import '../view_models/no_internet_connection.dart';
// import 'show_slider_dialog.dart';
//
// import 'package:rxdart/rxdart.dart';
//
// AssetsAudioPlayer? assetsAudioPlayer;
// List<Audio> mediaItems = [];
// late List<StreamSubscription> subscriptions;
//
// // ignore: must_be_immutable
// class AudiobookPlayerPage_3 extends StatefulWidget {
//   late BookIntroduction audiobook;
//
//   AudiobookPlayerPage_3({
//     Key? key,
//     required this.audiobook,
//   }) : super(key: key);
//
//   @override
//   State<AudiobookPlayerPage_3> createState() => _AudiobookPlayerPage_3State();
// }
//
// class _AudiobookPlayerPage_3State extends State<AudiobookPlayerPage_3>
//     with InternetConnection, LoadDataFromAPI {
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     dataIsLoading = widget.audiobook.id != previousAudiobookInPlayId;
//
//   }
//
//   Future _initMediaItems() async {
//     customDio = await CustomDio.dio
//         .post('dashboard/books/${widget.audiobook.slug}/audio');
//
//     if (customDio.statusCode == 200) {
//       if (widget.audiobook.id != previousAudiobookInPlayId) {
//         print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
//         setState(() {
//           for (Map<String, dynamic> mediaItem in customDio.data['data']) {
//             mediaItems.add(
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
//          assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
//
//           subscriptions = [];
//
//           subscriptions.add(assetsAudioPlayer!.playlistAudioFinished.listen((data) {
//             print('playlistAudioFinished : $data');
//           }));
//
//           subscriptions.add(assetsAudioPlayer!.audioSessionId.listen((sessionId) {
//             print('audioSessionId : $sessionId');
//           }));
//
//           dataIsLoading = false;
//
//         });
//
//         openPlayer();
//
//         audiobookIsPlaying.$ = true;
//
//       }
//     }
//
//     return customDio;
//   }
//
//   bool x = false;
//   bool y = false;
//
//   void openPlayer() async {
//     await assetsAudioPlayer!.open(
//       Playlist(audios: mediaItems, startIndex: 0),
//       showNotification: true,
//       autoStart: true,
//     );
//
//   }
//
//
//   Audio find(List<Audio> source, String fromPath) {
//     return source.firstWhere((element) => element.path == fromPath);
//
//   }
//
//   // @override
//   // void dispose() {
//   //  if(x) {
//   //    assetsAudioPlayer!.dispose();
//   //    print('dispose');
//   //    super.dispose();
//   //  }
//   // }
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
//
//
//
//             setState(() {
//
//               audiobookInPlayId = -1;
//               audiobookIsPlaying.$ = false;
//
//               // await audioPlayerHandler.updateQueue([]);
//               // audioPlayerHandler.stop();
//               // audioPlayerHandler.onTaskRemoved();
//               // audioPlayerHandler.seek(Duration(microseconds: 0));
//               // await audioPlayerHandler.skipToQueueItem(0);
//
//               previousAudiobookInPlayId = -1;
//               mediaItems.clear();
//
//               x =true;
//
//               // await audioPlayerHandler.dispose();
//
//
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
//   Widget _body() {
//     if(x) {
//       print('1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
//
//       return FutureBuilder(
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           return Center(child: CustomCircularProgressIndicator());
//         },
//         future: assetsAudioPlayer!.dispose(),
//       );
//     } else {
//
//       if ((dataIsLoading) && (widget.audiobook.id != previousAudiobookInPlayId)) {
//         return FutureBuilder(
//           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             if (snapshot.hasData) {
//               return _innerBody();
//             } else {
//               return Center(child: CustomCircularProgressIndicator());
//             }
//           },
//           future: _initMediaItems(),
//         );
//       } else {
//         if (demoOfBookIsPlaying.of(context)) {
//           print('2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222');
//
//           return _innerBody();
//         } else {
//
//           if(assetsAudioPlayer!.isPlaying.value) {
//             print('333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333');
//
//             return _innerBody();
//           } else {
//             print('444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444');
//
//             return FutureBuilder(
//               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                 return  _innerBody();
//               },
//               future: assetsAudioPlayer!.playOrPause(),
//             );
//           }
//
//
//         }
//       }
//     }
//   }
//
//   Widget _innerBody() {
//     Widget _body = SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 48.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               SizedBox(
//                 height: 20,
//               ),
//               Stack(
//                 fit: StackFit.passthrough,
//                 children: <Widget>[
//                   StreamBuilder<Playing?>(
//                       stream: assetsAudioPlayer!.current,
//                       builder: (context, playing) {
//                         if (playing.data != null) {
//                           if(!x)  {
//                             final myAudio = find(
//                                 mediaItems, playing.data!.audio.assetAudioPath);
//                             print(playing.data!.audio.assetAudioPath);
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Neumorphic(
//                                 style: NeumorphicStyle(
//                                   depth: 8,
//                                   surfaceIntensity: 1,
//                                   shape: NeumorphicShape.concave,
//                                   boxShape: NeumorphicBoxShape.circle(),
//                                 ),
//                                 child: myAudio.metas.image?.path == null
//                                     ? const SizedBox()
//                                     : myAudio.metas.image?.type ==
//                                     ImageType.network
//                                     ? Image.network(
//                                   myAudio.metas.image!.path,
//                                   height: 150,
//                                   width: 150,
//                                   fit: BoxFit.contain,
//                                 )
//                                     : Image.asset(
//                                   myAudio.metas.image!.path,
//                                   height: 150,
//                                   width: 150,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             );
//                           }
//
//                         }
//                         return SizedBox.shrink();
//                       }),
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: NeumorphicButton(
//                       style: NeumorphicStyle(
//                         boxShape: NeumorphicBoxShape.circle(),
//                       ),
//                       padding: EdgeInsets.all(18),
//                       margin: EdgeInsets.all(18),
//                       onPressed: () {
//                         AssetsAudioPlayer.playAndForget(
//                             Audio('assets/audios/horn.mp3'));
//                       },
//                       child: Icon(
//                         Icons.add_alert,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               assetsAudioPlayer!.builderCurrent(
//                   builder: (context, Playing? playing) {
//                     return Column(
//                       children: <Widget>[
//                         assetsAudioPlayer!.builderLoopMode(
//                           builder: (context, loopMode) {
//                             return PlayerBuilder.isPlaying(
//                                 player: assetsAudioPlayer!,
//                                 builder: (context, isPlaying) {
//                                   return PlayingControls(
//                                     loopMode: loopMode,
//                                     isPlaying: isPlaying,
//                                     isPlaylist: true,
//                                     onStop: () {
//                                       assetsAudioPlayer!.stop();
//                                     },
//                                     toggleLoop: () {
//                                       assetsAudioPlayer!.toggleLoop();
//                                     },
//                                     onPlay: () {
//                                       assetsAudioPlayer!.playOrPause();
//                                     },
//                                     onNext: () {
//                                       //_assetsAudioPlayer.forward(Duration(seconds: 10));
//                                       assetsAudioPlayer!.next(
//                                           keepLoopMode:
//                                           true /*keepLoopMode: false*/);
//                                     },
//                                     onPrevious: () {
//                                       assetsAudioPlayer!.previous(
//                                         /*keepLoopMode: false*/);
//                                     },
//                                   );
//                                 });
//                           },
//                         ),
//                         assetsAudioPlayer!.builderRealtimePlayingInfos(
//                             builder: (context, RealtimePlayingInfos? infos) {
//                               if (infos == null) {
//                                 return SizedBox();
//                               }
//                               //print('infos: $infos');
//                               return Column(
//                                 children: [
//
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       NeumorphicButton(
//                                         onPressed: () {
//                                           assetsAudioPlayer!
//                                               .seekBy(Duration(seconds: -10));
//                                         },
//                                         child: Text('-10'),
//                                       ),
//                                       SizedBox(
//                                         width: 12,
//                                       ),
//                                       NeumorphicButton(
//                                         onPressed: () {
//                                           assetsAudioPlayer!
//                                               .seekBy(Duration(seconds: 10));
//                                         },
//                                         child: Text('+10'),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               );
//                             }),
//                       ],
//                     );
//                   }),
//               SizedBox(
//                 height: 20,
//               ),
//               assetsAudioPlayer!.builderCurrent(
//                   builder: (BuildContext context, Playing? playing) {
//                     return SongsSelector(
//                       audios: mediaItems,
//                       onPlaylistSelected: (myAudios) {
//                         assetsAudioPlayer!.open(
//                           Playlist(audios: myAudios),
//                           showNotification: true,
//                           headPhoneStrategy:
//                           HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
//                           audioFocusStrategy: AudioFocusStrategy.request(
//                               resumeAfterInterruption: true),
//                         );
//                       },
//                       onSelected: (myAudio) async {
//                         try {
//                           await assetsAudioPlayer!.open(
//                             myAudio,
//                             autoStart: true,
//                             showNotification: true,
//                             playInBackground: PlayInBackground.enabled,
//                             audioFocusStrategy: AudioFocusStrategy.request(
//                                 resumeAfterInterruption: true,
//                                 resumeOthersPlayersAfterDone: true),
//                             headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//                             notificationSettings: NotificationSettings(
//                               //seekBarEnabled: false,
//                               //stopEnabled: true,
//                               //customStopAction: (player){
//                               //  player.stop();
//                               //}
//                               //prevEnabled: false,
//                               //customNextAction: (player) {
//                               //  print('next');
//                               //}
//                               //customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
//                               //customPauseIcon: AndroidResDrawable(name:'ic_pause_custom'),
//                               //customPlayIcon: AndroidResDrawable(name:'ic_play_custom'),
//                             ),
//                           );
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       playing: playing, duration: Duration(),
//                     );
//                   }),
//               /*
//                   PlayerBuilder.volume(
//                       player: _assetsAudioPlayer,
//                       builder: (context, volume) {
//                         return VolumeSelector(
//                           volume: volume,
//                           onChange: (v) {
//                             _assetsAudioPlayer.setVolume(v);
//                           },
//                         );
//                       }),
//                    */
//               /*
//                   PlayerBuilder.forwardRewindSpeed(
//                       player: _assetsAudioPlayer,
//                       builder: (context, speed) {
//                         return ForwardRewindSelector(
//                           speed: speed,
//                           onChange: (v) {
//                             _assetsAudioPlayer.forwardOrRewind(v);
//                           },
//                         );
//                       }),
//                    */
//               /*
//                   PlayerBuilder.playSpeed(
//                       player: _assetsAudioPlayer,
//                       builder: (context, playSpeed) {
//                         return PlaySpeedSelector(
//                           playSpeed: playSpeed,
//                           onChange: (v) {
//                             _assetsAudioPlayer.setPlaySpeed(v);
//                           },
//                         );
//                       }),
//                    */
//             ],
//           ),
//         ),
//       ),
//     );
//
//     if (connectionStatus == ConnectivityResult.none) {
//       assetsAudioPlayer!.stop();
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
//     return assetsAudioPlayer!.builderCurrent(
//         builder: (context, Playing? playing) {
//           return Column(
//             children: <Widget>[
//               assetsAudioPlayer!.builderLoopMode(
//                 builder: (context, loopMode) {
//                   return PlayerBuilder.isPlaying(
//                       player: assetsAudioPlayer!,
//                       builder: (context, isPlaying) {
//                         return PlayingControls(
//                           loopMode: loopMode,
//                           isPlaying: isPlaying,
//                           isPlaylist: true,
//                           onStop: () {
//                             assetsAudioPlayer!.stop();
//                           },
//                           toggleLoop: () {
//                             assetsAudioPlayer!.toggleLoop();
//                           },
//                           onPlay: () {
//                             assetsAudioPlayer!.playOrPause();
//                           },
//                           onNext: () {
//                             //_assetsAudioPlayer.forward(Duration(seconds: 10));
//                             assetsAudioPlayer!.next(
//                                 keepLoopMode: true /*keepLoopMode: false*/);
//                           },
//                           onPrevious: () {
//                             assetsAudioPlayer!.previous(/*keepLoopMode: false*/);
//                           },
//                         );
//                       });
//                 },
//               ),
//             ],
//           );
//         });
//   }
//
//   PlayerBuilder _progressBar() {
//     return assetsAudioPlayer!.builderRealtimePlayingInfos(
//         builder: (context, RealtimePlayingInfos? infos) {
//           if (infos == null) {
//             return SizedBox();
//           }
//           return PositionSeekWidget(
//             playerBottomNavigationBar: false,
//             currentPosition: infos.currentPosition,
//             duration: infos.duration,
//             seekTo: (to) {
//               assetsAudioPlayer!.seek(to);
//             },
//           );
//         });
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
//     assetsAudioPlayer!.builderCurrent(
//         builder: (BuildContext context, Playing? playing) {
//           return SongsSelector(
//             audios: mediaItems,
//             onPlaylistSelected: (myAudios) {
//               assetsAudioPlayer!.open(
//                 Playlist(audios: myAudios),
//                 showNotification: true,
//                 headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
//                 audioFocusStrategy:
//                 AudioFocusStrategy.request(resumeAfterInterruption: true),
//               );
//             },
//             onSelected: (myAudio) async {
//               try {
//                 await assetsAudioPlayer!.open(
//                   myAudio,
//                   autoStart: true,
//                   showNotification: true,
//                   playInBackground: PlayInBackground.enabled,
//                   audioFocusStrategy: AudioFocusStrategy.request(
//                       resumeAfterInterruption: true,
//                       resumeOthersPlayersAfterDone: true),
//                   headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//                   notificationSettings: NotificationSettings(
//                     seekBarEnabled: false,
//                     stopEnabled: true,
//                     customStopAction: (player) {
//                       player.stop();
//                     },
//                     prevEnabled: false,
//                     customNextAction: (player) {
//                       print('next');
//                     },
//                     customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
//                     customPauseIcon: AndroidResDrawable(name: 'ic_pause_custom'),
//                     customPlayIcon: AndroidResDrawable(name: 'ic_play_custom'),
//                   ),
//                 );
//               } catch (e) {
//                 print(e);
//               }
//             },
//             playing: playing,
//             duration: Duration(),
//           );
//         }));
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
//   twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
//   final twoDigitSeconds =
//   twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
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
//         required this.audios,
//         required this.onSelected,
//         required this.onPlaylistSelected,
//         required this.duration});
//
//   Widget _image(Audio item) {
//     if (item.metas.image == null) {
//       return SizedBox(height: 40, width: 40);
//     }
//
//     return item.metas.image?.type == ImageType.network
//         ? Image.network(
//       item.metas.image!.path,
//       height: 40,
//       width: 40,
//       fit: BoxFit.cover,
//     )
//         : Image.asset(
//       item.metas.image!.path,
//       height: 40,
//       width: 40,
//       fit: BoxFit.cover,
//     );
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
//               SliderStyle(variant: Colors.grey, accent: Colors.grey[500]),
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