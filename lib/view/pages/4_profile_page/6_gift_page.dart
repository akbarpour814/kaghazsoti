import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/view_models/custom_text_field.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:sizer/sizer.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({Key? key}) : super(key: key);

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  final TextEditingController _textEditingController = TextEditingController();
  late bool _giftCodeRegistered;

  @override
  void initState() {
    _giftCodeRegistered = false;

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
      title: const Text('هدیه'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.gift_outline,
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

  Center _body() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ثبت کد هدیه',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Divider(
                height: 4.0.h,
                thickness: 1.0,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: TextField(
                  readOnly: false,
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    helperText: 'کد هدیه',
                    errorText: false ? '' : null,
                    suffixIcon: Icon(
                        Ionicons.code_working_outline
                    ),
                  ),
                  onChanged: (String text) {},
                ),
              ),
              Center(
                child: SizedBox(
                  width: 100.0.w - (2 * 5.0.w),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _giftCodeRegistered =
                            _giftCodeRegistered ? false : true;
                      });
                    },
                    label: Text(
                      _giftCodeRegistered ? 'کد هدیه ثبت شد' : 'ثبت کد هدیه',
                    ),
                    icon: Icon(_giftCodeRegistered
                        ? Ionicons.checkmark_done_outline
                        : Ionicons.checkmark_outline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
