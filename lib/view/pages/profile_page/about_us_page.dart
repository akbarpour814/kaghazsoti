import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takfood_seller/main.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  late String _appLogoPath;
  late String _whatsappPhoneNumber;
  late String _email;
  late String _websiteAddress;
  late String _textOfShare;
  late String _introductionText;

  @override
  void initState() {
    _appLogoPath = 'assets/images/logo.1e799436.jpg';
    _whatsappPhoneNumber = '+989337502650';
    _email = 'Emailinwonderland@yahoo.com';
    _websiteAddress = 'www.kaghazsoti.com';
    _textOfShare = 'بهترین و جدیدترین کتاب های صوتی را با ما بشنوید.\n\nراه های ارتباط با ما:\n\nواتساپ: $_whatsappPhoneNumber\nایمیل: $_email\nوب سایت: $_websiteAddress\n\nدانلود از طریق: \n\n\nوب سایت:';
    _introductionText = ' جستجویِ مبدأ ادبیات جهان شاید از پیگیریِ نجوایِ خیال انگیزِ نخستینی ممکن شود که بشریت توانسته بود، با آن، گردِ کشفِ آتش، در میانِ ترس و دلهره های گوناگون، پشت به تاریکی هایِ ناشناخته در گوشِ اجتماع همنوعانش بخواند تا شبِ آشفته ای را به صبح روشنی برسانند. صدایِ بر زمین کوفتن هایِ تقلیدی از رقص هایِ شبانه ی شکار یا هیاهویِ هماهنگِ جمعی برای ایجاد دلهره در نهاد دشمنانِ پنهان و آشکار، سبب خلق امیدی می شد که امروز به نوعی از هنر یا ادبیات اطلاق می شود؛ و یا ممکن است آوایِ خیالبافیِ یک بشرِ دیرینه از سرزمین هایِ دوری که به تنهایی رفتنی نبود، وسیله یِ ایجاد شجاعتی گردیده باشد که برای مهاجرتی طولانی به یمنِ آن همراهانی بیابد و این اولین داستان سُرایِ زمین برای اصنافش از ندیده های خود تصاویری جذاب و شگفت آور بسازد. با بستن چشم ها آن روزها را می شود در رویا دید و شنید؛ این ابتدای ادبیات جهان اگر که باشد اما در خلال آن، از نوشته های به جا مانده با خط هیراگیلیف بر سنگ, دیوار و پوست ها یا منشور هایِ صلحِ میخی بر کتیبه ها و نگاره ها گرفته تا کتوب صحافی شده خطیِ به یادگار مانده از نوابغِ بشر که گاه تاریخ را می نگاشتند، گاه در چهره ی نمایشنامه نویسان میدان های شلوغ نمایش (مملو از چشمانِ براقِ تماشاگران) ظاهر می شدند و گاه در نقش پیام رسانان اخلاق و علم شعر می سراییدند، بودند و دیگرانی که با دغدغه نجاتِ زبان ملیِ خود به توسکانی, پارسی, سانسکریت, انگلیسی, اسپانیولی و قص الی هذا می نگاشتند. همه اینها را باید بخشی از گستره یِ تاریخ ادبیات دانست که به خودی خود گونه ما را منحصر به فرد معرفی می کند. تصور ابتدا در جایی که هستیم و یا حتی آن گونه که در پایان خواهیم بود، همه دستاوردهای دیگر هنر می تواند باشد.\n\nآری وسعت ادبیات به وسعت ذهن هاست چنان که پهنای آسمان را می توان با آن مقایسه نمود و همین موضوع دلیل محکم چرایی است که چگونه هنوز از کنار آتش تا ایستگاه هایِ فضایی، یعنی بر، یا روی زمین به دیده یِ شاعرانه به خود یا هستی می نگریم.\n\nاگرچه کسی به درستی نمی داند که عمر ادبیات ایران تا چه اندازه با نخستین لحظه های عمر ادبیات جهان فاصله داشته است اما قدمت و کیفیت این هنر در تاریخ حتی در میان ملل گوناگون صد البته با وجود هر آنچه بد که بر آن و این مرز و بوم رفته، هرگز بر کسی پوشیده نیست و می بینیم که همچنان، چگونه بر بامِ جاودان ِگذشته یِ هنر در کنار نوابغ دیگر, بی شمار از ادیبان ایرانی با آثار اعجاب انگیزی به نظم به نثر با قلم هاشان ایستاده اند. هر آینه ملت این کشور متمدن هرگز از بزرگان خود غافل نبوده و همیشه قدردانِ هنرمندانِ جاوید خود بوده اند و خواهند بود, در حالی که به دیده یِ احترام و توجهِ مناسب بر شاعرانِ و نویسندگان سایر کشور های جهان (در حال و گذشته) می نگرند. پس با وجودی که روزمرگی و مشکلات دنیای متمدن یا اقتصاد تاثیرات منفی زیادی بر توجهات به وجود آورده است اما اهمیتِ ادبیات همیشه در نظر ایرانیان مهم و پا برجا بوده و به امید خواهد ماند.\n\nسایت کاغذ صوتی بر آن است تا برای سهولت استفاده از آثار ادبی بر اساس معیارهای مناسب، منتخبِ کوچکی از دریایِ بی کرانِ ادبیات ایران و جهان گرد آورد تا هموطنانِ عزیز در قالبِ فایل‌های صوتی یا متنی در کتاب خانه های خود بگنجانند. در این مسیر همکاری انتشارات و هنرمندان محترم (گویندگان, نویسندگان و مترجمان) که راه را برای ارائه آثار دقیق و با کیفیت هموار می نمایند شایسته بهترین احترامات است و سایت کاغذ صوتی با فشردن دست هر یک و با نهایت فروتنی، سپاس, قدردانی و احترام بی نهایت خود را از پیش و تا همیشه به ایشان ابراز می کند.\n\nیادآور می شویم که در کاغذ صوتی هیچ گونه کتابی بدونِ اخذ مجوز های لازم و رضایتِ انتشارات و نویسندگان یا مترجمان ارائه نمی شود و علاقه مندان می توانید با خیال آسوده و از طریق افزارهای اختصاصی موبایل (android-ios) یا به طور مستقیم از سایت کاغذ صوتی استفاده نمایید و در صورت تمایل به همکاری با سپری کردن آزمون های سطح سنجی آنلاین یا حضوری با ما در ارتباط باشند.\n\nدر نهایت امید آن داریم که روزی سرانه یِ مطالعه در کشور عزیزمان ایران به جایگاه شایسته یِ خود، یعنی برابر با نفسِ اهمیتِ ادبیاتِ ایران در جهان برسد.';

    super.initState();
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
      title: const Text('درباره ما'),
      automaticallyImplyLeading: false,
      leading: const Icon(
        Ionicons.information_outline,
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 5.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _appLogo(),
                Expanded(
                  child: SizedBox(
                    width: 50.0.w,
                    height: 20.0.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'راه های ارتباط با ما:',
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _launcherToWhatsapp(),
                                  _launcherToEmail(),
                                  _launcherToWebsite(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _share(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _introductionTextWidget(),
          ],
        ),
      ),
    );
  }

  Image _appLogo() {
    return Image.asset(
      _appLogoPath,
      width: 40.0.w,
    );
  }

  Flexible _launcherToWhatsapp() {
    return Flexible(
      child: InkWell(
        onTap: () {
          if (Platform.isAndroid) {
            launch('https://wa.me/$_whatsappPhoneNumber/');
          } else {
            launch('https://api.whatsapp.com/send?phone=$_whatsappPhoneNumber');
          }
        },
        child: Icon(
          Ionicons.logo_whatsapp,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _launcherToEmail() {
    return Flexible(
      child: InkWell(
        onTap: () {
          launch('mailto:$_email?');
        },
        child: Icon(
          Ionicons.logo_yahoo,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _launcherToWebsite() {
    return Flexible(
      child: InkWell(
        onTap: () {
          launch('https://$_websiteAddress/');
        },
        child: Icon(
          Ionicons.earth_outline,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Flexible _share() {
    return Flexible(
      child: ElevatedButton(
        onPressed: () {
          Share.share(
            _textOfShare,
            subject: 'کاغذ صوتی',
          );
        },
        child: const Text(
          'ما را به اشتراک بگذارید.',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Padding _introductionTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        _introductionText,
        style: const TextStyle(height: 1.7),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
