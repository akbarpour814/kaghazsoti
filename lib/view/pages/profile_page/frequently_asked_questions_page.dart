import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../main.dart';
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
  late List<List<String>> _frequentlyAskedQuestions;
  late List<bool> _displayOfAnswers;
  late int _previousIndex;

  @override
  void initState() {
    _frequentlyAskedQuestions = [
      [
        'چطور میشه کتاب صوتی خریداری شده از طریق اپلیکیشن کاغذ صوتی را دانلود کنیم؟',
        'ارتباط گوشی رو به اینترنت برقرار کنید.وارد حساب کاربریتان شوید.گزینه کتابخانه روانتخاب کنید.در این قسمت تصویر کاور کتاب خریداری شده برای شما نمایش داده میشه که می تونید با لمس سه نقطه مقابل عنوان و انتخاب گزینه "پخش یا نمایش کتاب" عنوان رو انتخاب کنید.و در صفحه نمایش داده شده کنار هر بخش از کتاب با لمس فلش روی به پایین بخش دلخواه دانلود کنید و لمس فلش روبه جلو بخش مورد نظر را رو گوش کنید',
      ],
      [
        'چطور می توانم اعتبار بخرم؟',
        'شما به دو روش زیر می‌تونید اعتبارتون رو افزایش بدید:\n\nاز طریق وبسایت: گزینه‌ی "حساب کاربری" رو انتخاب کنید و از زیر منوی اون وارد قسمت "شارژ کیف پول" بشید. در این صفحه شما میتونید بسته‌های پیشنهادی کاغذ صوتی رو که با تخفیف ارائه شدن، ثبت کنین یا به میزان دلخواه اعتبارتون رو اضافه کنید.\n\nاز طریق اپلیکیشن: وارد قسمت "نمایه من" بشید و گزینه‌ی "اعتبار من" رو انتخاب کنید. در این قسمت شما میتونید بسته‌های پیشنهادی کاغذ صوتی رو که با تخفیف ارائه شدن، ثبت کنین یا به میزان دلخواه اعتبارتون رو اضافه کنید.',
      ],
      [
        'کتاب های من دانلود نمیشه، چیکار کنم؟',
        'اول مطمئن بشید که از آخرین نسخه‌ی کاغذ صوتی استفاده می‌کنید و بعد چک کنید که فضای کافی در حافظه‌ی تلفن همراهتون دارید.',
      ],
      [
        'چطوری میشه کتاب صوتی را هدیه داد؟',
        'وارد حساب کاربری خود شوید. عنوان مورد نظر خود رو انتخاب کنید. در این صفحه یک کادر با عنوان "خرید هدیه" را به شما نشان میشه، روی آن کلیک کنید. در قسمت بعد قیمت عنوان رو به شما نشان میشه. شما می تونید به دو روش "استفاده از اعتبار" و توسط درگاه بانکی هزینه عنوان رو پرداخت و سپس گزینه "تایید سفارش" رو بزنید. بعد از پرداخت موفقیت آمیز کد هدیه در سفارش خرید نمایش میده و برای هدیه گیرنده ارسال کنید.',
      ],
      [
        'نمیتوانم وارد حساب کاربری خودم بشم!',
        'اگر زمان ورود (لاگین) به اپلیکیشن با خطای "رمز عبور یا ایمیل اشتباه است" مواجه می‌شید، از طریق لینک "رمز عبورم را فراموش کرده‌ام" اقدام به تغییر رمز عبورتون کنید. اگر مشکل برطرف نشد، برای بررسی بیشتر با تیم پشتیبانی کاغذ صوتی در ارتباط باشید.',
      ],
      [
        'چطوری میشه از طریق مرورگر، فایل های کتاب صوتی را دانلود کرد؟',
        'بخاطر حفظ حقوق ناشر فقط از طریق اپلیکشن کاغذ صوتی امکان دانلود هست.',
      ],
      [
        'چطوری میشه در اپلیکیشن کاغذ صوتی ثبت نام کرد؟',
        '• اول اپلیکشن کاغذ صوتی رو با توجه به نوع سیستم عامل گوشی مورد استفادتون دانلود و نصب کنید.\n• بعد از نصب، برنامه کاغذ صوتی رو باز کنید.\n• گزینه "ثبت نام" رو لمس کنید.\n• در فیلد نام و نام خانوادگی خود وارد کنید.\n• در فیلد ایمیل، ایمیل متعبر وارد کنید.\n• کلمه عبور دلخواه خود وارد کنید.',
      ],
      [
        'چطوری میشه در وب سایت کاغذ صوتی ثبت نام کرد؟',
        '• روی نوار بالای صفحه سمت چپ گزینه "ورود/ثبت نام" رو انتخاب کنید\n• گزینه "ثبت نام" رو لمس کنید\n• در فیلد نام و نام خانوادگی خود وارد کنید.\n• در فیلد ایمیل، ایمیل متعبر وارد کنید.\n• کلمه عبور دلخواه خود وارد کنید.',
      ],
      [
        'آیا میشه کتاب چاپی برای تولید کتاب صوتی معرفی کنیم؟',
        'بله، در قسمت تماس با ما از طریق اپلیکشن درخواست خود را ثبت کنید بعد از بررسی جواب درخواست از طریق کاغذ صوتی داده میشود.',
      ],
      [
        'هزینه عنوان را پرداخت کردم ولی کتاب در کتابخانم نیست.',
        'مبنای شناسایی کتابخانه شما و خرید هایی که انجام دادید آدرس ایمیلی هست که هنگام ثبت نام در نظر گرفتید و هنگام ثبت نام هم با همان ایمیل اقدام کردید.توجه داشته باشید که حتما با همان ایمیل وارد حساب کاربریتون شوید تا کتابهاتون رو مشاهده کنید.\nاین حالت زمانی پیش میاد که یا از آدرس ایمیل دیگرتون استفاده کردید و یا اینکه اشتباه تایپی درج ایمیلتون داشتید.\nحالت بعدی این هست که شما عنوان رو اشتباها به عنوان هدیه خریدید.(به بخش هدیه برید و کد هدیه برا خودتون ثبت کنید.)\nبرای بررسی دقیق هم میتونید یکی از اطلاعات خرید (شش رقم اول و چهار رقم آخر کارت بانکی که با اون پرداخت رو ا نجام دادید، شماره سفارش و یا کد پیگیری پرداخت) به همراه نام کتاب رو در بخش تماس با ما ثبت کنید تا همکاران ما پیگیری لازم رو داشته باشند.\nبه دلیل عدم ارتباط درگاه پرداخت بانک با سرور کاغذ صوتی خرید نیمه کاره میمونه.بانک بعد از 30 دقیقه وجه رو بحسابتون برمیگردونه و لازمه مجدد خرید کنید. توجه داشته باشید برای تراکنش های زیر 50 هزار تومان بعضی از بانک ها پیامک ارسال نمی کنند.نیاز هست که موجودی حسابتون رو بررسی کنید.',
      ],
      [
        'چطور از طریق مرورگر خرید کنیم؟',
        'از طریق مرورگر رایانه یا تلفن همراهتان وارد وبسایت کاغذ صوتی شوید.\nروی گزینه "ورود/ثبت نام" کلیک کنید.\nصفحه ای به شما نمایش داده میشه که در کادر اول آدرس ایمیل و در کادر دوم رمز عبورتان را وارد می کنید.\nروی گزینه ورود کلیک کنید.\nدر منوی اصلی گزینه"محصولات" رو انتخاب کنید در این قسمت عناوین به تفکیک موضوع دسته بندی شدند.\nدسته بندی مورد نظر رو انتخاب کنید تا عناوین مربوط به آنرا ببینید.\nتصاویر کوچکی از کاور کتاب های صوتی در این قسمت وجود داره،با حرکت موس روی آنها و با کلیک بر روی آیکون مثلثی شکل"شروع" میتونید نمونه ای از کتاب رو بشنوید.\nاگر که قصد خرید این کتاب را داری میتونید بر روی کاور کتاب کلیک کنید تا به صفحه اصلی کتاب برید(در این صفحه اطلاعات بیشتری در خصوص کتاب صوتی و عوامل تولید اون وجود داره) روی گزینه"خرید با قیمت....تومان" کلیک کنید.\nدر این قسمت در سمت راست عنوان مورد نظر و قیمت را نمایش می دهد و در سمت چپ کادری نمایش داده می شود.اگر در حساب کاربری خود اعتبار دارید می تونید گزینه "استفاده از اعتبار" را فعال کنید. در آخر میشه وجه رو از درگاه بانک پرداخت کنید (همه کارت های بانکی که عضو شبکه شتاب هستند امکان پرداخت وجه رو دارند). اگر با مبلغ درج شده موافق هستید پس از پرداخت گزینه "تایید سفارش" رو انتخاب کنید.\nحالا به درگاه پرداخت هدایت شدید. لازمه که اطلاعات مربوط به کارت بانکی را در کادر های مشخص وارد کنید. در انتها بر روی گزینه پرداخت کلیک کنید.\nاگر پرداخت شما موفقیت آمیز باشه پیام "عملیات خرید با موفقیت انجام شد" به همراه سایر اطلاعات پرداخت رو میبینید.\nبرای گوش دادن به کتاب های صوتی از اپلیکیشن کاغذ صوتی منوی کتابخانه من امکان پذیر هست.',
      ],
      [
        'چطوری از طریق اپلیکیشن کاغذ صوتی خرید کنیم؟',
        'ابتدا اپلیکشن کاغذ صوتی متناسب با سیستم عامل دستگاهتون رو انتخاب کنید.\nاپلیکشن کاغذ صوتی رو نصب کنید و وارد حساب کاربریتون بشید.\nمی تونید با انتخاب گزینه "دسته بندی"و "فروشگاه" کتاب مورد نظرتان روانتخاب کنید.\nدر این قسمت تصویر کتاب مورد نظر همراه قیمت و توضیح درباره کتاب مورد نظر نمایش داده میشه.عنوان گزینه "خرید با قیمت.... تومان" رو لمس کنید.\nکتاب به سبد خرید افزوده میشه و سفارش خود را نهایی کنید.\nدر این مرحله به درگاه بانک هدایت میشه. اطلاعات کارت خود را به همراه کد امنیتی که در پایینتر نمایش داد شده وارد کنید و در آخر گزینه "پرداخت" رو انتخاب کنید.\nخرید شما با موفقیت انجام شده و کتاب در کتابخانه شما قرار گرفته است و می تونید اون رو دانلود کنید.',
      ],
      [
        'چطوری میشه از کد هدیه استفاده کنیم؟',
        'از طریق مرورگر رایانه و یا تلفن همراهتان وارد حساب کاربریتون شوید.در قسمت بالا سایت سمت راست بر روی گزینه "هدیه" کلیک کنید.\nکد هدیه رو بدون تغییر کاراکترها در کادر مربوطه وارد کنید و روی گزینه "ثبت" کلیک کنید. کتاب مورد نظر در کتابخانه من نمایش داده میشه.',
      ],
      [
        'بعد از اینکه کتاب صوتی را خریدم چطوری دانلودش کنم؟',
        'بعد از ثبت سفارش کتاب مورد نظر به حساب کاربریتان اضافه میشه و صفحه ای به شما نمایش داده میشه که میتونید بر اساس نیاز و دستگاهی که در اختیار دارید از کتابتان استفاده کنید.\nدانلود مجددا کتاب های صوتی در هر زمانی برای شما ممکن هست و محدودیتی در تعداد دفعات دانلود وجود نداره.\nاپلیکشن کاغذ صوتی متناسب با سیستم عامل خود را رو دانلود کنید. پس از نصب آن وارد حساب کاربریتان شوید. روی گزینه کتابخانه کلیک کنید.کتاب صوتی که خریداری کردید رو در این قسمت می بینید.برای دانلود عکس کاور کتاب را لمس کنید یا از طریق سه نقطه رو به روی عنوان گزینه "پخش یا مطالعه" رو لمس کنید ، و در صفحه نمایش داده شده بخش مورد نظر از طریق فلش رو به پایین دانلود کنید ،یکبار کتاب دانلود شده و بعد از آن بصورت آفلاین میتونید به آن گوش بدید.لازم بدونید که برای دانلود کتاب های صوتی نیاز است از اینترنت پایدار و پر سرعت استفاده کنید.',
      ],
      [
        'چطوری از کتاب های جدید، کاغذ صوتی باخبر شویم؟',
        'در صفخه اصلی سایت یا اپلیکیشن کتاب های صوتی جدید هر بخش نمایش داده شده.',
      ],
      [
        'بعد از خرید تا چه مدت می توانیم کتاب صوتی را دانلود کنیم؟',
        'کتاب صوتی خریداری شده برای همیشه در کتابخانه حساب کاربری شما قرار میگیره و بدون محدودیت در تعداد دفعات میتونید اون رو دانلود کنید.محدودیتی در این خصوص وجود نداره.',
      ],
      [
        'اگر مشکل در روند استفاده کتاب صوتی برام پیش اومد چطوری رفعش کنم؟',
        'ما تلاش کردیم که تمام سوالاتی که ممکنه برای کاربر پیش بیاد در بخش سوالات متداول به همراه پاسخ قرار بدیم.اگر که جواب سوالتون رو در این قسمت پیدا نکردید میتونید با پشتیبانی در ارتباط باشید .در روزهای کاری از ساعت 9 تا 17 پاسخگوی ایمیل ها و تماس های شما هستیم و این اطمینان رو به شما می دیم که رسیدگی به درخواست شما کاربران عزیز اولین اولویت کاری ما می باشد.',
      ],
      [
        'پیشنهادات و انتقادات خودمون رو چطوری منتقل کنیم؟',
        'قطعا دیدگاه و نظر ارزنده شما، باعث پیشرفت و خدمت رسانی بهتر کاغذ صوتی میشه. از این رو مشتاقانه منتظر ارسال پیشنهادات و انتقادات شما کاربران عزیزان هستیم. شما میتونید از طریق بخش تماس با ما پیشنهاد خود ثبت کنید ومجموعه کاغذ صوتی رو در ارتقای کمی و کیفی همراهی کنید.',
      ],
      [
        'چطوری می توانیم با کاغذ صوتی همکاری کنیم؟',
        'استفاده از تجریبات و همکاری با شما برای ما بسیار ارزشمنده.شما می تونید به صفحه ی تماس با ما نوع همکاری ثبت کنید و بعد از بررسی جواب به درخواست شما از طرف کاغذ صوتی داده میشه.',
      ],
      [
        'سوال و یا مشکلی دارید که جواب آن را در اینجا پیدا نمی کنید؟',
        'میتوانید در بخش تماس با ما سوال خود ثبت کنید کاغذ صوتی در کمترین زمان ممکن پاسخ شما میده.',
      ],
    ];

    _displayOfAnswers =
        List<bool>.generate(_frequentlyAskedQuestions.length, (index) => false);

    _previousIndex = -1;

    super.initState();
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

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: List<Widget>.generate(
              _frequentlyAskedQuestions.length,
              (index) {
                return _questionAndAnswer(
                  _frequentlyAskedQuestions[index][0],
                  _frequentlyAskedQuestions[index][1],
                  index,
                );
              },
            ),
          ),
         /* SizedBox(
            width: 100.0.w - (2 * 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const ContactUsPage();
                    },
                  ),
                );
              },
              child: const Text('هدف ما رضایت شماست، پس با هما تماس بگیرید!'),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _questionAndAnswer(String question, String answer, int index) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: index == _frequentlyAskedQuestions.length - 1 ? const Border() : Theme.of(context).cardTheme.shape,
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
            _displayOfAnswers[index] ? Ionicons.chevron_up_outline : Ionicons.chevron_down_outline,
          ),
        ),
      ),
    );
  }
}
