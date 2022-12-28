
import 'package:get/get_rx/src/rx_types/rx_types.dart';

extension RxStringExtension on RxString {
  String? get error {
    if (value.isEmpty) {
      return null;
    } else {
      return value;
    }
  }

  bool get hasError {
    if (error == null) {
      return false;
    } else {
      return true;
    }
  }
}