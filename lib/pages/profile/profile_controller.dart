import 'package:get/get.dart';
import 'package:kaz_reader/pages/profile/profile_enum.dart';

class ProfileController extends GetxController with StateMixin<List<ProfileEnum>?> {
  ProfileController() {
    change(ProfileEnum.values, status: RxStatus.success());
  }
}
