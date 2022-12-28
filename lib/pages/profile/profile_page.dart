//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//------/packages
import 'package:ionicons/ionicons.dart';
import 'package:kaz_reader/pages/profile/profile_controller.dart';
import 'package:kaz_reader/pages/profile/profile_enum.dart';
import 'package:restart_app/restart_app.dart';

//------/view/pages/profile_page
import '../../widgets/custom_circular_progress_indicator.dart';
import '../../widgets/password/password_controller.dart';
import '../../widgets/password/password_widget.dart';
import '../about_us/about_us_page.dart';
import '../edit_profile/edit_profile_page.dart';
import '../cart/cart_page.dart';
import '../contact_us/contact_us_page.dart';
import '../faq/faq_page.dart';
import '../marked/marked_page.dart';
import '../password_settings/password_settings_page.dart';
import '../purchase_history/purchase_history_page.dart';

//------/view/view_models
import '../../widgets/category_name.dart';

//------/main
import '/main.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: body(context),
      //body: PasswordWidget(controller: PasswordController(), readOnly: false,),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('نمایه من'),
      leading: const Icon(
        Ionicons.person_outline,
      ),
    );
  }


  Widget body(BuildContext context) {
    return ListView.builder(
      itemCount: controller.state!.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == controller.state!.length) {
          return theme(context);
        } else if (index == controller.state!.length + 1) {
          return logOut();
        } else {
          ProfileEnum value = controller.state![index];

          return CategoryName(
            iconData: value.icon,
            title: value.title,
            lastCategory: false,
            page: value.page,
          );
        }
      },
    );
  }

  Card theme(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: ListTile(
        leading: Icon(
          MyApp.themeNotifier.value == ThemeMode.light
              ? Ionicons.sunny_outline
              : Ionicons.moon_outline,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          MyApp.themeNotifier.value == ThemeMode.light
              ? 'زمینه تیره'
              : 'زمینه روشن',
        ),
        trailing: Switch(
          onChanged: (value) {
            MyApp.themeNotifier.value =
            MyApp.themeNotifier.value == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          },
          value: MyApp.themeNotifier.value == ThemeMode.dark,
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  InkWell logOut() {
    return InkWell(
      onTap: () async {
        await sharedPreferences.setBool('firstLogin', true);

        await sharedPreferences.setStringList('bookCartSlug', []);

        Restart.restartApp();
      },
      child: const Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: ListTile(
          leading: Icon(
            Ionicons.exit_outline,
            color: Colors.redAccent,
          ),
          title: Text(
            'خروج از حساب کاربری',
          ),
        ),
      ),
    );
  }

}

