import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:ionicons/ionicons.dart';
import '../../../controller/custom_dio.dart';
import '../../../controller/custom_response.dart';
import '../../../main.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../../view_models/no_internet_connection.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

class FrequentlyAskedQuestionsPage extends StatefulWidget {
  const FrequentlyAskedQuestionsPage({Key? key}) : super(key: key);

  @override
  _FrequentlyAskedQuestionsPageState createState() =>
      _FrequentlyAskedQuestionsPageState();
}

class _FrequentlyAskedQuestionsPageState
    extends State<FrequentlyAskedQuestionsPage> {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late List<FrequentlyAskedQuestion> _frequentlyAskedQuestions;
  late List<bool> _displayOfAnswers;
  late int _previousIndex;

  @override
  void initState() {
    _dataIsLoading = true;
    _frequentlyAskedQuestions = [];

    _previousIndex = -1;

    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future _initFrequentlyAskedQuestions() async {
    _customDio = await CustomDio.dio.get('faq');

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      for (Map<String, dynamic> frequentlyAskedQuestion
          in _customResponse.data) {
        _frequentlyAskedQuestions
            .add(FrequentlyAskedQuestion.fromJson(frequentlyAskedQuestion));
      }

      _displayOfAnswers = List<bool>.generate(
          _frequentlyAskedQuestions.length, (index) => false);
      _dataIsLoading = false;
    }

    return _customDio;
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
    return _dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : Center(
                      child: CustomCircularProgressIndicator(
                          message: 'لطفاً شکیبا باشید.'));
            },
            future: _initFrequentlyAskedQuestions(),
          )
        : _innerBody();
  }

  Widget _innerBody() {
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(
        child: NoInternetConnection(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () {
          setState(() {
            _dataIsLoading = true;
          });

          return _initFrequentlyAskedQuestions();
        },
        child: ListView.builder(
          itemCount: _frequentlyAskedQuestions.length,
          itemBuilder: (BuildContext context, int index) => _questionAndAnswer(
            _frequentlyAskedQuestions[index].question,
            _frequentlyAskedQuestions[index].answer,
            index,
          ),
        ),
      );
    }
  }

  Widget _questionAndAnswer(String question, String answer, int index) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: Theme.of(context).cardTheme.shape,
      child: ListTile(
        title: Text(question),
        subtitle: Visibility(
          visible: _displayOfAnswers[index],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 4.0.h,
              ),
              Text(
                answer,
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

    answer = json['a'];
  }
}
