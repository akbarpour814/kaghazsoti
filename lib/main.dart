import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takfood_seller/controller/database.dart';
import 'package:takfood_seller/model/comment.dart';
import 'package:takfood_seller/model/purchase.dart';
import 'package:takfood_seller/test.dart';
import 'package:takfood_seller/view/pages/login_pages/splash_page.dart';
import 'package:takfood_seller/view/pages/login_pages/login_page.dart';
import 'package:takfood_seller/view/view_models/audiobook_player_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';

import 'package:sizer/sizer.dart';

import 'model/book.dart';
import 'view/pages/0_library_page/0_library_page.dart';
import 'view/pages/1_category_page/0_category_page.dart';
import 'view/pages/2_home_page/0_home_page.dart';
import 'view/pages/3_search_page/0_search_page.dart';
import 'view/pages/4_profile_page/0_profile_page.dart';

import 'package:persian_number_utility/persian_number_utility.dart';


final SharedValue<bool> audioIsPlaying = SharedValue(value: false);

AudioPlayer audioPlayer = AudioPlayer();

late Book audiobookInPlay;



final PersistentTabController persistentTabController =
    PersistentTabController(initialIndex: 2);
List<Widget> pages = const [
   LibraryPage(),
   CategoryPage(),
   HomePage(),
   SearchPage(),
   ProfilePage(),
];

Color select = const Color(0xFF005C6B);
Color unselect = Colors.grey;

late SharedPreferences sharedPreferences;

late List<PersistentBottomNavBarItem> items = [
  PersistentBottomNavBarItem(
    icon: const Icon(Ionicons.library_outline),
    title: 'کتابخانه من',
    activeColorSecondary: select,
    inactiveColorPrimary: unselect,
  ),
  PersistentBottomNavBarItem(
    icon: const Icon(Ionicons.albums_outline),
    title: 'دسته بندی',
    activeColorSecondary: select,
    inactiveColorPrimary: unselect,
  ),
  PersistentBottomNavBarItem(
    icon: const Icon(Ionicons.home_outline),
    title: 'خانه',
    activeColorSecondary: Colors.white,
    inactiveColorPrimary: unselect,
    activeColorPrimary: const Color(0xFF005C6B),
  ),
  PersistentBottomNavBarItem(
    icon: const Icon(Ionicons.search_outline),
    title: 'جست و جو',
    activeColorSecondary: select,
    inactiveColorPrimary: unselect,
  ),
  PersistentBottomNavBarItem(
    icon: const Icon(Ionicons.person_outline),
    title: 'نمایه من',
    activeColorSecondary: select,
    inactiveColorPrimary: unselect,
  ),
];

// List<Book> books = List.generate(50, (index) => book);

late AudioHandler _audioHandler;
void main() {
  Database database = Database();
  runApp(SharedValue.wrapApp(
    const MyApp(),
  ),);
}

// void main() {
//   runApp(SharedValue.wrapApp(
//     const MyApp(),
//   ),);
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              title: 'Kaghaze souti',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Vazir',
                primarySwatch: MaterialColor(0xFF005C6B, {
                50: const Color(0xFFD9E2E4),
                100: const Color(0xFFC2D4D7),
                200: const Color(0xFFA9C5C9),
                300: const Color(0xFF91B6BC),
                400: const Color(0xFF79A7AF),
                500: const Color(0xFF6198A1),
                600: const Color(0xFF488993),
                700: const Color(0xFF307A86),
                800: const Color(0xFF186B79),
                900: const Color(0xFF005C6B),
              }),
                primaryColor: const Color(0xFF005C6B),
                backgroundColor: Colors.white,
                dividerColor: const Color(0xFF005C6B),
                accentColor: const Color(0xFF005C6B),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF005C6B),
                  foregroundColor: Colors.white,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Vazir',
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xFF005C6B),
                ),
                cardTheme: const CardTheme(
                  shape: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.4,
                    ),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF005C6B),
                    ),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF005C6B),
                  foregroundColor: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(

                  helperStyle: const TextStyle(color: Color(0xFF005C6B)),
                  suffixIconColor: const Color(0xFF005C6B),
                  focusColor: const Color(0xFF005C6B).withOpacity(0.6),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF005C6B),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF005C6B),
                    ),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF005C6B),
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xFF005C6B),
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF005C6B),
                    ),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF005C6B),
                    ),
                  ),
                ),
                textSelectionTheme: TextSelectionThemeData(cursorColor: const Color(0xFF005C6B), selectionColor: const Color(0xFF005C6B).withOpacity(0.6), selectionHandleColor: const Color(0xFF005C6B),),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: 'Vazir',
                primarySwatch: Colors.teal,
                primaryColor: const Color(0xFF005C6B),
                backgroundColor: Colors.black,
                dividerColor: const Color(0xFF005C6B),
                accentColor: const Color(0xFF005C6B),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF005C6B),
                  foregroundColor: Colors.white,
                  centerTitle: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Vazir',
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xFF005C6B),
                ),
                cardTheme: const CardTheme(
                  shape: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.4,
                    ),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFF005C6B),
                    ),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF005C6B),
                  foregroundColor: Colors.white,
                ),
                textSelectionTheme: TextSelectionThemeData(cursorColor: const Color(0xFF005C6B), selectionColor: const Color(0xFF005C6B).withOpacity(0.6), selectionHandleColor: const Color(0xFF005C6B),),

              ),
              themeMode: currentMode,
              builder: (context, child) => Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              ),
              home: const SafeArea(child: LoginPages()),
            );
          },
        );
      },
    );
  }
}

class LoginPages extends StatefulWidget {
  const LoginPages({Key? key}) : super(key: key);

  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        controller: persistentTabController,
        screens: pages,
        items: items,
        navBarStyle: NavBarStyle.style18,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );

    return const SafeArea(
      child: LoginPages(),
    );
  }
}





/*Book book = Book(
  id: 1,
  name: 'شازده کوچولو',
  category: 'کتاب صوتی',
  subcategory: 'رمان کوتاه',
  author: 'آنتوان دو سنت اگزوپری',
  announcer: 'الهام ایران نیا',
  fileSize: 152,
  publisherOfPrintedVersion: 'آسو',
  printedVersionYear: 1396,
  publisherOfAudioVersion: 'کاغذ صوتی',
  audioVersionYear: 1399,
  numberOfChapters: 27,
  numberOfPages: 115,
  duration: '02:39:18',
  price: "20000",
  marked: false,
  numberOfVotes: 2,
  numberOfStars: 2,
  aboutBook:
      'آنتوان دو سنت اگزوپه‌ری در ۲۹ ژوئن ۱۹۰۰ در لیون فرانسه متولد شد. اگزوپه‌ری تا قبل از جنگ جهانی دوم، خلبان تجاری موفقی بود. با آغاز جنگ، به نیروی هوایی فرانسه در شمال آفریقا پیوست. اگزوپه‌ری کتاب شازده کوچولو را با الهام از دیدار با کودکی در آفریقا، نوشته است. کتاب شازده کوچولو به بیش از سیصد زبان ترجمه شده و بارها مورد اقتباس تئاتری و سینمایی قرار گرفته است. آنتوان دو سنت اگزوپه‌ری در ۱۹۴۴ در حادثه‌ای که برای هواپیمایش رخ داد درگذشت. او بعد از مرگ به عنوان قهرمان ملی فرانسه شناخته شد.',
  partOfTheBook:
      'سلام\nشازده کوچولو اگرچه وقتی سرش را چرخاند هیچی ندید، اما مؤدبانه جواب داد: سلام\nصدا گفت: من اینجام، زیر درخت سیب. \nشازده کوچولو گفت: تو کی هستی؟ چقدر تو خوشگلی! \n- من یه روباهم. \n- بیا و با من بازی کن، من خیلی دلم گرفته. \n- من نمیتونم با تو بازی کنم، آخه من هنوز اهلی نشدم. \nشازده کوچولو گفت: چه حیف! معذرت میخوام جناب روباه. اما اهلی کردن یعنی چی؟\n-  تو اهل این دور و برها نیستی، پی چی می گردی؟\n- دنبال آدما می گردم. اهلی کردن یعنی چی؟\n- آدما، اونا تفنگ دارن و شکار میکنن. این کاراشون اسباب دلخوریه. اونا مرغ پرورش می دهند، این تنها \n کار مورد علاقه شونه. تو دنبال مرغ می گردی؟\n- نه من دنبال دوست می گردم، اهلی کردن یعنی چی؟\n-  یه چیزی که پاک فراموش شده معنیش ایجاد علاقه کردنه. \n- ایجاد علاقه کردن؟',
  comments: [''],
  audioPath: 'audioPath',
  bookCoverPath: 'assets/images/backgroundImage.jpg',
  otherBooksByThePublisher: [
    book1,
    book1,
    book1,
    book1,
  ],
  relatedBooks: [
    book1,
    book1,
  ],
);

Book book1 = Book(
  id: 2,
  name: 'شازده کوچولو',
  category: 'کتاب صوتی',
  subcategory: 'رمان کوتاه',
  author: 'آنتوان دو سنت اگزوپری',
  announcer: 'الهام ایران نیا',
  fileSize: 152,
  publisherOfPrintedVersion: 'آسو',
  printedVersionYear: 1396,
  publisherOfAudioVersion: 'کاغذ صوتی',
  audioVersionYear: 1399,
  numberOfChapters: 27,
  numberOfPages: 115,
  duration: '02:39:18',
  price: "20000",
  marked: false,
  numberOfVotes: 2,
  numberOfStars: 2,
  aboutBook:
      'شازده کوچولو داستانی اثر آنتوان دو سنت اگزوپری است که نخستین بار در سپتامبر سال ۱۹۴۳ در نیویورک منتشر شد. این کتاب به بیش از ۳۰۰ زبان و گویش ترجمه شده و با فروش بیش از ۲۰۰ میلیون نسخه، یکی از پرفروش‌ترین کتاب‌های تاریخ محسوب می‌شود. کتاب شازده کوچولو «خوانده شده‌ترین» و «ترجمه شده‌ترین» کتاب فرانسوی ‌زبان جهان است و به عنوان بهترین کتاب قرن ۲۰ در فرانسه انتخاب شده‌است. از این کتاب به‌طور متوسط سالی ۱ میلیون نسخه در جهان به فروش می‌رسد. این کتاب در سال ۲۰۰۷ نیز به عنوان کتاب سال فرانسه برگزیده شد. در این داستان سنت اگزوپری به شیوه‌ای سوررئالیستی به بیان فلسفه خود از دوست داشتن و عشق و هستی می‌پردازد. طی این داستان سنت اگزوپری از دیدگاه یک کودک، که از سیارکی به نام ب۶۱۲ آمده، پرسشگر سؤالات بسیاری از آدم‌ها و کارهایشان است.',
  partOfTheBook:
      'سلام\nشازده کوچولو اگرچه وقتی سرش را چرخاند هیچی ندید، اما مؤدبانه جواب داد: سلام\nصدا گفت: من اینجام، زیر درخت سیب. \nشازده کوچولو گفت: تو کی هستی؟ چقدر تو خوشگلی! \n- من یه روباهم. \n- بیا و با من بازی کن، من خیلی دلم گرفته. \n- من نمیتونم با تو بازی کنم، آخه من هنوز اهلی نشدم. \nشازده کوچولو گفت: چه حیف! معذرت میخوام جناب روباه. اما اهلی کردن یعنی چی؟\n-  تو اهل این دور و برها نیستی، پی چی می گردی؟\n- دنبال آدما می گردم. اهلی کردن یعنی چی؟\n- آدما، اونا تفنگ دارن و شکار میکنن. این کاراشون اسباب دلخوریه. اونا مرغ پرورش می دهند، این تنها \n کار مورد علاقه شونه. تو دنبال مرغ می گردی؟\n- نه من دنبال دوست می گردم، اهلی کردن یعنی چی؟\n-  یه چیزی که پاک فراموش شده معنیش ایجاد علاقه کردنه. \n- ایجاد علاقه کردن؟',
  comments: [''],
  audioPath: 'audioPath',
  bookCoverPath: 'assets/images/backgroundImage.jpg',
  otherBooksByThePublisher: [],
  relatedBooks: [],
);*/

Purchase purchase = Purchase(
  number: 199,
  type: 'کتاب',
  prices: 20000,
  date: DateTime.now(),
  status: PurchaseStatus.cancelled,
);

