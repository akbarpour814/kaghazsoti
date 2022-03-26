import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/comment.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/datetime_format.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';
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

class _ContactUsPageState extends State<ContactUsPage> {
  late Response<dynamic> _customDio;
  late CustomResponse _customResponse;
  TextEditingController _textEditingController = TextEditingController();
  String? _topic;
  String? _errorText;
  late List<Topic> _topics;
  late bool _commentPosted;
  //late List<bool> _displayOfDetails;
  late int _previousIndex;
  late List<Comment> _comments;

  @override
  void initState() {
    _topics = Topic.values;
    _commentPosted = false;
    _previousIndex = -1;
    _comments = [];

    super.initState();
  }

  Future _initComments() async {
    _customDio = await CustomDio.dio.get('dashboard/tickets');

    if (_customDio.statusCode == 200) {
      _comments.clear();

      _customResponse = CustomResponse.fromJson(_customDio.data);

      for (Map<String, dynamic> comment in _customResponse.data['data']) {
        _comments.add(Comment.fromJson(comment));
      }
    }

    return _customDio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: const PlayerBottomNavigationBar(),
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

  FutureBuilder _body() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? _innerBody()
            : const Center(child: CustomCircularProgressIndicator());
      },
      future: _initComments(),
    );
  }

  SingleChildScrollView _innerBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectACommentTopic(),
            _commentTextField(),
            _commentRegistrationButton(),
            _userComments(),
          ],
        ),
      ),
    );
  }

  Column _selectACommentTopic() {
    return Column(
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
          thickness: 1.0,
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 16.0),
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
            _errorText = null;
          });
        },
      ),
    );
  }

  SizedBox _commentRegistrationButton() {
    return SizedBox(
      width: 100.0.w - (2 * 5.0.w),
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            if((_topic == null) && (_textEditingController.text.isEmpty)) {
              _errorText = 'لطفاً نظر خود را به همراه موضوع وارد کنید.';
            } else if(_topic == null) {
              _errorText = 'لطفاً موضوع را وارد کنید.';
            } else if(_textEditingController.text.isEmpty) {
              _errorText = 'لطفاً نظر خود را وارد کنید.';
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
    );
  }

  void _commentRegistration() async {
    _customDio = await CustomDio.dio.post(
      'dashboard/tickets',
      data: {
        'title': _topic,
        'body': _textEditingController.text,
      },
    );

    setState(() {
      if (_customDio.statusCode == 200) {
        _topic = null;
        _textEditingController = TextEditingController();

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.checkmark_done_outline,
            'نظر شما با موفقیت ثبت شد.',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            Ionicons.refresh_outline,
            'لطفاً دوباره امتحان کنید.',
          ),
        );
      }
    });
  }

  Column _userComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'نظرات شما',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        const Divider(
          height: 32.0,
          thickness: 1.0,
        ),
        Column(
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
                  borderRadius:
                  const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  children: [
                    Property(
                        property: 'موضوع',
                        value: _comments[index].topic.title!,
                        valueInTheEnd: false,
                        lastProperty: false),
                    Property(
                        property: 'تاریخ ارسال',
                        value: _comments[index].date,
                        valueInTheEnd: false,
                        lastProperty: false),
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
                      visible: _comments[index].displayOfDetails,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 24.0,
                            thickness: 1.0,
                          ),
                          Property(
                              property: 'دیدگاه شما',
                              value: '',
                              valueInTheEnd: false,
                              lastProperty: false),
                          Text(
                            _comments[index].text,
                            textAlign: TextAlign.justify,
                          ),
                          Visibility(
                            visible: _comments[index].status ==
                                CommentStatus.answered,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Divider(
                                  height: 24.0,
                                  thickness: 1.0,
                                ),
                                Property(
                                    property: 'پاسخ ما',
                                    value: '',
                                    valueInTheEnd: false,
                                    lastProperty: false),
                                Text(
                                  _comments[index].response,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _comments[index].status ==
                                CommentStatus.cancelled,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  label:
                                  const Text('ویرایش و ارسال دوباره'),
                                  icon: const Icon(Ionicons.create_outline),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _comments[index].status ==
                                CommentStatus.waiting,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                width: 100.0.w - (2 * 18.0) - (2 * 5.0.w),
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  label: const Text('لغو ارسال نظر'),
                                  icon: const Icon(
                                      Ionicons.trash_bin_outline),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 24.0,
                      thickness: 1.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (index == _previousIndex &&
                              _comments[index].displayOfDetails) {
                            _comments[index].displayOfDetails = false;
                          } else if (index == _previousIndex &&
                              !_comments[index].displayOfDetails) {
                            _comments[index].displayOfDetails = true;
                          } else if (index != _previousIndex) {
                            if (_previousIndex != -1) {
                              _comments[index].displayOfDetails = false;
                            }
                            _comments[index].displayOfDetails = true;
                          }

                          _previousIndex = index;
                        });
                      },
                      child: Icon(
                        _comments[index].displayOfDetails
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
