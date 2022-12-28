import 'package:get/get.dart';
import 'package:kaz_reader/pages/about_us/about_us_controller.dart';
import 'package:kaz_reader/pages/category/category_controller.dart';
import 'package:kaz_reader/pages/edit_profile/edit_profile_controller.dart';
import 'package:kaz_reader/pages/faq/faq_controller.dart';
import 'package:kaz_reader/pages/home/home_controller.dart';
import 'package:kaz_reader/pages/library/library_controller.dart';
import 'package:kaz_reader/pages/marked/marked_controller.dart';
import 'package:kaz_reader/pages/profile/profile_controller.dart';
import 'package:kaz_reader/pages/search/search_controller.dart';

export 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
    Get.lazyPut<AboutUsController>(() => AboutUsController(), fenix: true);
    Get.lazyPut<EditProfileController>(() => EditProfileController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<FAQController>(() => FAQController(), fenix: true);
    Get.lazyPut<LibraryController>(() => LibraryController(), fenix: true);
    Get.lazyPut<MarkedController>(() => MarkedController(), fenix: true);

  }
}
