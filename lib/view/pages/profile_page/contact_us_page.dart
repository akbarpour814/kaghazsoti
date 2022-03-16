import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/model/comment.dart';
import 'package:takfood_seller/model/user.dart';
import 'package:takfood_seller/view/view_models/datetime_format.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:takfood_seller/view/view_models/property.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/database.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({
    Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _topic;
  late List<Topic> _topics;
  late bool _commentPosted;
  late List<bool> _displayOfDetails;
  late int _previousIndex;


  @override
  void initState() {
    _topics = Topic.values;
    _commentPosted = false;
    _displayOfDetails =
    List<bool>.generate(database.user.comments.length, (index) => false);
    _previousIndex = -1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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

  SingleChildScrollView _body() {
    OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(_topic == null ? 'لطفا موضوع دیدگاه خود را انتخاب کنید.' : 'موضوع: $_topic',)),
                Flexible(
                  child: InkWell(onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => true,
                          child: SimpleDialog(
                            children: List<InkWell>.generate(_topics.length, (index) => InkWell(onTap: () {
                              setState(() {
                                _topic = _topics[index].title!;
                              });

                              Navigator.of(context).pop();
                            }, child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_topics[index].title!),
                            ),),),
                          ),
                        );
                      },
                    );
                  }, child: Icon(Ionicons.ellipsis_vertical_outline, color: Theme.of(context).primaryColor,),),
                ),
              ],
            ),
            const Divider(
              height: 32.0,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'دیدگاه خود را بنویسید.',
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
              ),
            ),
            SizedBox(
              width: 100.0.w - (2 * 5.0.w),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _commentPosted = _commentPosted ? false : true;
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
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('نظرات شما'),
            ),
            const Divider(
              height: 32.0,
              thickness: 1.0,
            ),
            Column(
              children: List.generate(
                database.user.comments.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        top: 0.0,
                        bottom: index == database.user.comments.length - 1 ? 0.0 : 8.0,
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
                            Property(property: 'موضوع', value: database.user.comments[index].topic.title!, valueInTheEnd: false, lastProperty: false),
                            Property(property: 'تاریخ ارسال', value: database.user.comments[index].date.format(), valueInTheEnd: false, lastProperty: false),
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
                                            database.user.comments[index].status.title!,
                                            style: TextStyle(
                                              color: database.user.comments[index].status.color,
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
                                children: [
                                  const Divider(
                                    height: 24.0,
                                    thickness: 1.0,
                                  ),
                                  Property(property: 'دیدگاه شما', value: '', valueInTheEnd: false, lastProperty: false),
                                  Text(database.user.comments[index].text, textAlign: TextAlign.justify,),
                                  Visibility(
                                    visible: database.user.comments[index].status == CommentStatus.answered,
                                    child: Column(
                                      children: [
                                        const Divider(
                                          height: 24.0,
                                          thickness: 1.0,
                                        ),
                                        Property(property: 'پاسخ ما', value: '', valueInTheEnd: false, lastProperty: false),
                                        Text(database.user.comments[index].response, textAlign: TextAlign.justify,),
                                      ],
                                    ),),
                                  Visibility(
                                    visible: database.user.comments[index].status == CommentStatus.cancelled,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: SizedBox(
                                        width:  100.0.w - (2 * 18.0) - (2 * 5.0.w),
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          label: const Text('ویرایش و ارسال دوباره'),
                                          icon: const Icon(
                                              Ionicons.create_outline
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: database.user.comments[index].status == CommentStatus.waiting,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: SizedBox(
                                        width:  100.0.w - (2 * 18.0) - (2 * 5.0.w),
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          label: const Text('لغو ارسال نظر'),
                                          icon: const Icon(
                                              Ionicons.trash_bin_outline
                                          ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
