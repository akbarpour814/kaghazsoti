import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../../model/text_format.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../../view_models/no_internet_connection.dart';
import 'package:sizer/sizer.dart';

class FrequentlyAskedQuestionsPage extends StatefulWidget {
  const FrequentlyAskedQuestionsPage({Key? key}) : super(key: key);

  @override
  _FrequentlyAskedQuestionsPageState createState() =>
      _FrequentlyAskedQuestionsPageState();
}

class _FrequentlyAskedQuestionsPageState
    extends State<FrequentlyAskedQuestionsPage>
    with InternetConnection, LoadDataFromAPI {
  late List<FrequentlyAskedQuestion> _frequentlyAskedQuestions;
  late List<bool> _displayOfAnswers;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();

    _frequentlyAskedQuestions = [];
    _previousIndex = -1;
  }

  Future _initFrequentlyAskedQuestions() async {
    customDio = await CustomDio.dio.get('faq');

    if (customDio.statusCode == 200) {
      customResponse = CustomResponse.fromJson(customDio.data);

      for (Map<String, dynamic> frequentlyAskedQuestion
          in customResponse.data) {
        _frequentlyAskedQuestions
            .add(FrequentlyAskedQuestion.fromJson(frequentlyAskedQuestion));
      }

      setState(() {
        _displayOfAnswers = List<bool>.generate(
          _frequentlyAskedQuestions.length,
          (index) => false,
        );

        dataIsLoading = false;
      });
    }

    return customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('سوالات متداول کاغذ صوتی'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.help,
      ),
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(18.0),
            child: Icon(
              Ionicons.chevron_back_outline,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _body() {
    if (dataIsLoading) {
      return FutureBuilder(
        future: _initFrequentlyAskedQuestions(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _innerBody();
          } else {
            return Center(
              child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.',
              ),
            );
          }
        },
      );
    } else {
      return _innerBody();
    }
  }

  Widget _innerBody() {
    if (connectionStatus == ConnectivityResult.none) {
      setState(() {
        dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () {
          setState(() {
            dataIsLoading = true;
          });

          return _initFrequentlyAskedQuestions();
        },
        child: ListView(
          children: List<Card>.generate(
            _frequentlyAskedQuestions.length,
            (index) => _questionAndAnswer(
              _frequentlyAskedQuestions[index],
              index,
            ),
          ),
        ),
      );
    }
  }

  Card _questionAndAnswer(
      FrequentlyAskedQuestion frequentlyAskedQuestion, int index) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: Theme.of(context).cardTheme.shape,
      child: ListTile(
        title: Text(frequentlyAskedQuestion.question),
        subtitle: Visibility(
          visible: _displayOfAnswers[index],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 4.0.h,
              ),
              Text(
                frequentlyAskedQuestion.answer,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 2.0.h,
              ),
            ],
          ),
        ),
        trailing: InkWell(
          onTap: () {
            setState(() {
              if (index == _previousIndex && _displayOfAnswers[index]) {
                _displayOfAnswers[index] = false;
              } else if (index == _previousIndex && !_displayOfAnswers[index]) {
                _displayOfAnswers[index] = true;
              } else if (index != _previousIndex) {
                if (_previousIndex != -1) {
                  _displayOfAnswers[_previousIndex] = false;
                }
                _displayOfAnswers[index] = true;
              }

              _previousIndex = index;
            });
          },
          child: Icon(
            _displayOfAnswers[index]
                ? Ionicons.chevron_up_outline
                : Ionicons.chevron_down_outline,
          ),
        ),
      ),
    );
  }
}

class FrequentlyAskedQuestion {
  late String question;
  late String answer;

  FrequentlyAskedQuestion.fromJson(Map<String, dynamic> json) {
    question = json['q'];
    question = TextFormat.textFormat(text: question);

    answer = json['a'];
    answer = TextFormat.textFormat(text: answer);
  }
}
