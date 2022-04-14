import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kaghaze_souti/controller/internet_connection.dart';
import 'package:kaghaze_souti/controller/load_data_from_api.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../view_models/no_internet_connection.dart';
import '/main.dart';
import '/model/comment_data.dart';
import '/view/view_models/player_bottom_navigation_bar.dart';
import '/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/custom_dio.dart';

//import '../../../controller/database.dart';
import '../../../controller/custom_response.dart';
import '../../view_models/custom_circular_progress_indicator.dart';
import '../../view_models/custom_snack_bar.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> with InternetConnection, LoadDataFromAPI {
  TextEditingController _textEditingController = TextEditingController();
  String? _topic;
  String? _errorText;
  late List<Topic> _topics;
  late bool _commentPosted;
  late List<bool> _displayOfDetails;
  late int _previousIndex;
  late List<CommentData> _comments;



  @override
  void initState() {
    _topics = Topic.values;
    _commentPosted = false;
    _previousIndex = -1;
    _comments = [];

    super.initState();


  }


  Future _initComments() async {
    customDio = await CustomDio.dio.get('dashboard/tickets');

    if (customDio.statusCode == 200) {
      _comments.clear();

      customResponse = CustomResponse.fromJson(customDio.data);

      _comments.add(CommentData.fromJson(customResponse.data['data'][0]));

      _displayOfDetails = List<bool>.generate(_comments.length, (index) => false);

      dataIsLoading = false;
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
      title: const Text('تماس با ما'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.call_outline,
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
    return dataIsLoading
        ? FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? _innerBody()
                  : Center(
                      child: CustomCircularProgressIndicator(
                          message: 'لطفاً شکیبا باشید.'));
            },
            future: _initComments(),
          )
        : _innerBody();
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
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectACommentTopic(),
            _commentTextField(),
            _commentRegistrationButton(),
            const Divider(
              height: 0.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0.w, top: 0.0, right: 5.0.w, bottom: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'نظرات شما',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return CommentsPage(comments: _comments,);
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'نمایش همه',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Divider(
                      height: 0.0,
                    ),
                  ),
                  _userComments(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Padding _selectACommentTopic() {
    return Padding(
      padding: EdgeInsets.only(left: 5.0.w, top: 16.0, right: 5.0.w, bottom: 0.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _topic == null
                    ? 'لطفاً موضوع نظر خود را انتخاب کنید.'
                    : 'موضوع: $_topic',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => true,
                          child: SimpleDialog(
                            children: List<InkWell>.generate(
                              _topics.length,
                              (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    _topic = _topics[index].title!;

                                    _errorText = null;
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_topics[index].title!),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Ionicons.ellipsis_vertical_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 32.0,
          ),
        ],
      ),
    );
  }

  Padding _commentTextField() {
    OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );

    return Padding(
      padding: EdgeInsets.only(left: 5.0.w, top: 0.0, right: 5.0.w, bottom: 16.0),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          errorText: _errorText,
          hintText: 'لطفاً نظر خود را بنویسید.',
          border: _outlineInputBorder,
          focusedBorder: _outlineInputBorder,
          disabledBorder: _outlineInputBorder,
          enabledBorder: _outlineInputBorder,
          errorBorder: _outlineInputBorder,
          focusedErrorBorder: _outlineInputBorder,
        ),
        maxLines: 8,
        cursorColor: Theme.of(context).dividerColor.withOpacity(0.6),
        cursorWidth: 1.0,
        onChanged: (String text) {
          setState(() {
            if (_textEditingController.text.isEmpty) {
              _errorText = null;
            } else if (_textEditingController.text.length < 3) {
              _errorText = 'نظر شما باید بیش از حرف داشته باشد.';
            } else {
              _errorText = null;
            }
          });
        },
      ),
    );
  }

  Padding _commentRegistrationButton() {
    return Padding(
      padding: EdgeInsets.only(left: 5.0.w, top: 0.0, right: 5.0.w, bottom: 16.0),
      child: SizedBox(
        width: 100.0.w - (2 * 5.0.w),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              if ((_topic == null) && (_textEditingController.text.isEmpty)) {
                _errorText = 'لطفاً نظر خود را به همراه موضوع بنویسید.';
              } else if (_topic == null) {
                _errorText = 'لطفاً موضوع را انتخاب کنید.';
              } else if (_textEditingController.text.isEmpty) {
                _errorText = 'لطفاً نظر خود را بنویسید.';
              } else if (_textEditingController.text.length < 3) {
                _errorText = 'نظر شما باید بیش از حرف داشته باشد.';
              } else {
                _errorText = null;

                _commentRegistration();
              }
            });
          },
          label: Text(
            _commentPosted ? 'نظر شما ثبت شد' : 'ثبت نظر',
          ),
          icon: Icon(_commentPosted
              ? Ionicons.checkmark_done_outline
              : Ionicons.checkmark_outline),
        ),
      ),
    );
  }

  void _commentRegistration() async {
    customDio = await CustomDio.dio.post(
      'dashboard/tickets',
      data: {
        'title': _topic,
        'body': _textEditingController.text,
      },
    );

    setState(() {
      if (customDio.statusCode == 200) {
        _topic = null;
        _textEditingController = TextEditingController();
        dataIsLoading = true;

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.checkmark_done_outline,
            'نظر شما با موفقیت ثبت شد.',
            4,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.refresh_outline,
            'لطفاً دوباره امتحان کنید.',
            4,
          ),
        );
      }
    });
  }

  Widget _userComments() {
    if (_comments.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'شما تا کنون نظری به ثبت نرسانده اید.',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      );
    } else {


      return Column(
        children: List.generate(
          _comments.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              top: 0.0,
              bottom: index == _comments.length - 1 ? 0.0 : 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 18.0,
                top: 18.0,
                right: 18.0,
                bottom: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Property(
                    property: 'موضوع',
                    value: _comments[index].topic.title!,
                    valueInTheEnd: false,
                    lastProperty: false,
                  ),
                  Property(
                    property: 'تاریخ ارسال',
                    value: _comments[index].sentDate,
                    valueInTheEnd: false,
                    lastProperty: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      top: 0.0,
                      right: 0.0,
                      bottom: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Expanded(
                          child: Text('وضعیت:'),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  _comments[index].status.title!,
                                  style: TextStyle(
                                    color: _comments[index].status.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _displayOfDetails[index],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 24.0,
                        ),
                        Property(
                          property: 'دیدگاه شما',
                          value: '',
                          valueInTheEnd: false,
                          lastProperty: false,
                        ),
                        Text(
                          '- ${_comments[index].text}',
                          textAlign: TextAlign.justify,
                        ),
                        Visibility(
                          visible:
                              _comments[index].status == CommentStatus.answered,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 24.0,
                              ),
                              Property(
                                property: 'پاسخ ما',
                                value: '',
                                valueInTheEnd: false,
                                lastProperty: false,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List<Text>.generate(
                                  _comments[index].answers.length,
                                  (commentIndex) => Text(
                                    '${commentIndex + 1}- ${_comments[index].answers[commentIndex]}',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (index == _previousIndex &&
                            _displayOfDetails[index]) {
                          _displayOfDetails[index] = false;
                        } else if (index == _previousIndex &&
                            !_displayOfDetails[index]) {
                          _displayOfDetails[index] = true;
                        } else if (index != _previousIndex) {
                          if (_previousIndex != -1) {
                            _displayOfDetails[_previousIndex] = false;
                          }
                          _displayOfDetails[index] = true;
                        }

                        _previousIndex = index;
                      });
                    },
                    child: Icon(
                      _displayOfDetails[index]
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class CommentsPage extends StatefulWidget {
  late List<CommentData> comments;
  CommentsPage({Key? key, required this.comments,}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  late bool _dataIsLoading;
  late int _lastPage;
  late int _currentPage;
  late List<CommentData> _commentsTemp;
  late List<CommentData> _comments;
  late List<bool> _displayOfDetails;
  late int _previousIndex;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late RefreshController _refreshController;

  @override
  void initState() {
    _dataIsLoading = true;
    _previousIndex = -1;
    _commentsTemp = [];
    _comments = [];
    _currentPage = 1;

    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

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

  Future _initComments() async {
    _customDio = await CustomDio.dio.get('dashboard/tickets', queryParameters: {'page': _currentPage},);

    if (_customDio.statusCode == 200) {
      _customResponse = CustomResponse.fromJson(_customDio.data);

      _lastPage = _customResponse.data['last_page'];

      if(_currentPage == 1) {
        _comments.clear();
      }

      for (Map<String, dynamic> comment in _customResponse.data['data']) {
        _comments.add(CommentData.fromJson(comment));
      }

      setState(() {
        _commentsTemp.clear();
        _commentsTemp.addAll(_comments);

        _displayOfDetails = List<bool>.generate(_commentsTemp.length, (index) => false);

        _dataIsLoading = false;
        refresh = false;
        loading = false;
      });
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
      title: const Text('نظرات شما'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.call_outline,
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
    return _dataIsLoading ? FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : Center(
            child: CustomCircularProgressIndicator(
                message: 'لطفاً شکیبا باشید.'));
      },
      future: _initComments(),
    ) : _innerBody();
  }

  Widget _innerBody() {

    if(_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _dataIsLoading = true;
      });

      return const Center(child: NoInternetConnection(),);
    } else {
      if (_commentsTemp.isEmpty) {
        return const Center(
          child: Text('شما تا کنون نظری به ثبت نرسانده اید.'),
        );
      } else {
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext? context, LoadStatus? mode) {
              Widget bar;

              if ((mode == LoadStatus.idle) && (_currentPage == _lastPage) && (!_dataIsLoading)) {
                bar = Text(
                  'نظر دیگری یافت نشد.',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColor,
                  ),
                );
              } else if (mode == LoadStatus.idle) {
                bar = Text('لطفاً صفحه را بالا بکشید.',
                    style: TextStyle(color: Theme.of(context!).primaryColor));
              } else if (mode == LoadStatus.loading) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً شکیبا باشید.');
              } else if (mode == LoadStatus.failed) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً دوباره امتحان کنید.');
              } else if (mode == LoadStatus.canLoading) {
                bar = CustomCircularProgressIndicator(
                    message: 'لطفاً صفحه را پایین بکشید.');
              } else {
                bar = Text(
                  'نظر دیگری یافت نشد.',
                  style: TextStyle(color: Theme.of(context!).primaryColor),
                );
              }

              return SizedBox(
                height: 55.0,
                child: Center(child: bar),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: loading ? null : _onRefresh,
          onLoading: refresh ? null : _onLoading,
          child: ListView(
            children: List.generate(_commentsTemp.length, (index) =>  Padding(
              padding: EdgeInsets.only(
                left: 5.0.w,
                top: index == 0 ? 16.0 : 0.0,
                right: 5.0.w,
                bottom: index == _commentsTemp.length - 1 ? 0.0 : 16.0,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  top: 18.0,
                  right: 18.0,
                  bottom: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  children: [
                    Property(
                      property: 'موضوع',
                      value: _commentsTemp[index].topic.title!,
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Property(
                      property: 'تاریخ ارسال',
                      value: _commentsTemp[index].sentDate,
                      valueInTheEnd: false,
                      lastProperty: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0.0,
                        top: 0.0,
                        right: 0.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            child: Text('وضعیت:'),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    _commentsTemp[index].status.title!,
                                    style: TextStyle(
                                      color: _commentsTemp[index].status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _displayOfDetails[index],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 24.0,
                          ),
                          Property(
                            property: 'دیدگاه شما',
                            value: '',
                            valueInTheEnd: false,
                            lastProperty: false,
                          ),
                          Text(
                            '- ${_commentsTemp[index].text}',
                            textAlign: TextAlign.justify,
                          ),
                          Visibility(
                            visible:
                            _commentsTemp[index].status == CommentStatus.answered,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  height: 24.0,
                                ),
                                Property(
                                  property: 'پاسخ ما',
                                  value: '',
                                  valueInTheEnd: false,
                                  lastProperty: false,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Text>.generate(
                                    _commentsTemp[index].answers.length,
                                        (commentIndex) => Text(
                                      '${commentIndex + 1}- ${_commentsTemp[index].answers[commentIndex]}',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 24.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (index == _previousIndex &&
                              _displayOfDetails[index]) {
                            _displayOfDetails[index] = false;
                          } else if (index == _previousIndex &&
                              !_displayOfDetails[index]) {
                            _displayOfDetails[index] = true;
                          } else if (index != _previousIndex) {
                            if (_previousIndex != -1) {
                              _displayOfDetails[_previousIndex] = false;
                            }
                            _displayOfDetails[index] = true;
                          }

                          _previousIndex = index;
                        });
                      },
                      child: Icon(
                        _displayOfDetails[index]
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),),
          ),

        );
      }
    }


  }


  bool refresh = false;
  bool loading = false;
  void _onRefresh() async {
    try {
      // monitor network fetch
      setState(() {
        refresh = loading ? false : true;
        if (refresh) {
          _currentPage = 1;

          _initComments();

          print(_currentPage);
          print('refresh');
          print(refresh);
          print(loading);
        }
      });
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      if (_currentPage < _lastPage) {
        setState(() {
          loading = refresh ? false : true;

          if (loading) {
            _currentPage++;

            _initComments();
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.loadFailed();
    }
  }
}
