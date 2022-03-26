import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/book.dart';
import 'package:takfood_seller/view/view_models/book_introduction_page.dart';
import 'package:takfood_seller/view/view_models/progress_bar/custom_progress_bar.dart';
import 'package:takfood_seller/view/view_models/progress_bar/playOrPauseController.dart';
import 'package:sizer/sizer.dart';

import '../../controller/custom_dio.dart';
import 'custom_circular_progress_indicator.dart';

class AudiobookPlayerPage extends StatefulWidget {
  const AudiobookPlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  _AudiobookPlayerPageState createState() => _AudiobookPlayerPageState();
}

class _AudiobookPlayerPageState extends State<AudiobookPlayerPage> {
  Future _initParts() async {
    Response<dynamic> _customDio = await CustomDio.dio.post('dashboard/books/${audiobookInPlay.slug}/audio');

    if(_customDio.statusCode == 200 && audiobookInPlay.parts.isEmpty) {
      audiobookInPlay.setParts(_customDio.data['data']);

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: List<AudioSource>.generate(audiobookInPlay.parts.length, (index) => AudioSource.uri(Uri.parse(audiobookInPlay.parts[index].path),),),
        ),
      );
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { return snapshot.hasData ? _body() :  const Center(child: CustomCircularProgressIndicator()); }, future: _initParts(),),

      bottomNavigationBar: const Divider(
        height: 0.0,
        thickness: 1.0,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(audiobookInPlay.name),
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          setState(() {
            audioIsPlaying.$ = true;

            Navigator.of(context).pop();
          });
        },
        child: const Icon(
          Ionicons.chevron_down_outline,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            setState(() {
              audioPlayer.stop();

              audioIsPlaying.$ = false;

              Navigator.of(context).pop();
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.close_outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    Column _body = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 5.0.w,
            top: 16.0,
            right: 5.0.w,
            bottom: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bookCover(),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(audiobookInPlay.parts[audioPlayer.currentIndex ?? 0].name),
                        SizedBox(
                          height: 4.0.h,
                        ),
                        _buttons(),
                      ],
                    ),
                  ),
                ],
              ),
              _progressBar(),
              Text(
                'فهرست کتاب',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Divider(
            height: 0.0,
            thickness: 1.0,
          ),
        ),
        _bookIndex(),
      ],
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return SingleChildScrollView(child: _body);
    } else {
      return _body;
    }
  }

  Flexible _bookCover() {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return BookIntroductionPage(book: audiobookInPlay);
            },
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            shape: BoxShape.rectangle,
          ),
          width: 40.0.w,
          height: 20.0.h,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: defaultBookCover,
              image: audiobookInPlay.bookCoverPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Row _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _nextButton(),
        _playOrPauseButton(),
        _previousButton(),
      ],
    );
  }

  StreamBuilder _nextButton() {
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => Flexible(
        child: InkWell(
          onTap: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
          child: Icon(
            Ionicons.play_forward_outline,
            color: audioPlayer.hasNext ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Flexible _playOrPauseButton() {
    return Flexible(
      child: PlayOrPauseController(
        playerBottomNavigationBar: false,
      ),
    );
  }

  StreamBuilder<SequenceState?> _previousButton() {
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) => Flexible(
        child: InkWell(
          onTap: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
          child: Icon(
            Ionicons.play_back_outline,
            color: audioPlayer.hasPrevious ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Padding _progressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CustomProgressBar(
        timeLabelLocation: TimeLabelLocation.below,
        baseBarColor: const Color(0xFFC6DADE).withOpacity(0.4),
        progressBarColor: const Color(0xFF005C6B),
        bufferedBarColor: const Color(0xFFC6DADE),
        thumbColor: const Color(0xFF005C6B),
        thumbGlowColor: const Color(0xFF005C6B).withOpacity(0.6),
      ),
    );
  }

  Widget _bookIndex() {
    Column _bookIndex = Column(
      children: List<Card>.generate(
        audiobookInPlay.parts.length,
        (index) {
          Part _part = audiobookInPlay.parts[index];

          return Card(
            color: Colors.transparent,
            elevation: 0.0,
            shape: Theme.of(context).cardTheme.shape,
            child: ListTile(
              title: Text(_part.name),
              subtitle: Text(_part.time),
              trailing: index == audioPlayer.currentIndex! ? const Icon(Ionicons.download_outline) : null,
            ),
          );
        },
      ),
    );

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return _bookIndex;
    } else {
      return Expanded(
        child: SingleChildScrollView(
          child: _bookIndex,
        ),
      );
    }
  }
}
