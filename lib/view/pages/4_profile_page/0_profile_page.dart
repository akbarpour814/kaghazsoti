import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:restart_app/restart_app.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/pages/login_pages/splash_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/10_about_us_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/1_account_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/2_wallet_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/3_cart_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/4_purchase_history_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/5_marked_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/6_gift_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/7_password_setting_page.dart';
import 'package:takfood_seller/view/pages/4_profile_page/8_frequently_asked_questions_page.dart';
import 'package:takfood_seller/view/view_models/category_name.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';

import '../login_pages/login_page.dart';
import '9_contact_us_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      title: const Text('نمایه من'),
      leading: const Icon(
        Ionicons.person_outline,
      ),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _navigatorToAccountPage(),
          _navigatorToWalletPage(),
          _navigatorToCartPage(),
          _navigatorToPurchaseHistoryPage(),
          _navigatorToMarkedPage(),
          _navigatorToGiftPage(),
          _navigatorToPasswordSettingPage(),
          _navigatorToFrequentlyAskedQuestionsPage(),
          _navigatorToContactUsPage(),
          _navigatorToAboutUsPage(),
          _setThemeMode(),
          _logOut(),
        ],
      ),
    );
  }

  CategoryName _navigatorToAccountPage() {
    return CategoryName(
      iconData: Ionicons.person_outline,
      title: 'نمایش و ویرایش حساب کاربری',
      lastCategory: false,
      page: const AccountPage(),
    );
  }

  CategoryName _navigatorToWalletPage() {
    return CategoryName(
      iconData: Ionicons.wallet_outline,
      title: 'اعتبار من',
      lastCategory: false,
      page: const WalletPage(),
    );
  }

  CategoryName _navigatorToCartPage() {
    return CategoryName(
      iconData: Ionicons.cart_outline,
      title: 'سبد خرید',
      lastCategory: false,
      page: const CartPage(),
    );
  }

  CategoryName _navigatorToPurchaseHistoryPage() {
    return CategoryName(
      iconData: Ionicons.calendar_outline,
      title: 'تاریخچه خرید',
      lastCategory: false,
      page: const PurchaseHistoryPage(),
    );
  }

  CategoryName _navigatorToMarkedPage() {
    return CategoryName(
      iconData: Ionicons.bookmark_outline,
      title: 'نشان شده ها',
      lastCategory: false,
      page: const MarkedPage(),
    );
  }

  CategoryName _navigatorToGiftPage() {
    return CategoryName(
      iconData: Ionicons.gift_outline,
      title: 'هدیه',
      lastCategory: false,
      page: const GiftPage(),
    );
  }

  CategoryName _navigatorToPasswordSettingPage() {
    return CategoryName(
      iconData: Ionicons.key_outline,
      title: 'تغییر رمز',
      lastCategory: false,
      page: const PasswordSettingPage(),
    );
  }

  CategoryName _navigatorToFrequentlyAskedQuestionsPage() {
    return CategoryName(
      iconData: Ionicons.help,
      title: 'سوالات متداول',
      lastCategory: false,
      page: const FrequentlyAskedQuestionsPage(),
    );
  }

  CategoryName _navigatorToContactUsPage() {
    return CategoryName(
      iconData: Ionicons.call_outline,
      title: 'تماس با ما',
      lastCategory: false,
      page: const ContactUsPage(),
    );
  }

  CategoryName _navigatorToAboutUsPage() {
    return CategoryName(
      iconData: Ionicons.information_outline,
      title: 'درباره ما',
      lastCategory: false,
      page: const AboutUsPage(),
    );
  }

  Card _setThemeMode() {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: Theme.of(context).cardTheme.shape,
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

  InkWell _logOut() {
    return InkWell(
      onTap: () async {
        await sharedPreferences.setBool('logOut', true);

        Restart.restartApp();
      },
      child: const Card(
        color: Colors.transparent,
        elevation: 0.0,
        shape: Border(),
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
