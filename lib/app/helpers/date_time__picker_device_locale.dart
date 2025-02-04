import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:get/get.dart';

DateTimePickerLocale helperVerifyDeviceLocale() {
  switch (Get.deviceLocale.toString()) {
    case 'pt_BR':
      return DateTimePickerLocale.pt_br;
    case 'en_uS':
      return DateTimePickerLocale.en_us;
    default:
      return DateTimePickerLocale.en_us;
  }
}
