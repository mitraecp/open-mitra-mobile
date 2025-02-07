import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

Future<DateTime?> showMitraDatePicker({
  required DateTimePickerLocale currentLocale,
  required BuildContext context,
  DateTime? currentDate,
  bool hasToCompare = false,
  bool isStartDate = true,
  DateTime? compareDate,
}) async {

  var dateTimeNow = DateTime.now();

  DateTime? newSelectedDate;

  Rx<DateTime> selectedDate = currentDate != null
      ? currentDate.obs
      : DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day).obs;

  var dayOfWeek =
      DateFormat('EEE', '${Get.deviceLocale}').format(selectedDate.value).obs;
  var daySelected = DateFormat('d').format(selectedDate.value).obs;
  var mounthSelected =
      DateFormat('MMM', '${Get.deviceLocale}').format(selectedDate.value).obs;
  var yearSelected = DateFormat('y').format(selectedDate.value).obs;

  await showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 4, top: 16, right: 8, left: 18),
                    child: Obx(
                      () => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: dayOfWeek.value,
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                            TextSpan(
                              //NOTE: O formato de texto em inglês para data é diferente.
                              text: (Get.deviceLocale).toString() == 'en_US'
                                  ? ', ${mounthSelected.value} ${daySelected.value}'
                                  : ', ${daySelected.value}',
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                            TextSpan(
                              text: (Get.deviceLocale).toString() == 'en_US'
                                  ? ', '
                                  : 'for'.tr,
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                            TextSpan(
                              text: (Get.deviceLocale).toString() == 'en_US'
                                  ? yearSelected.value
                                  : mounthSelected.value,
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                            TextSpan(
                              text: (Get.deviceLocale).toString() == 'en_US'
                                  ? ''
                                  : 'for'.tr,
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                            TextSpan(
                              text: (Get.deviceLocale).toString() == 'en_US'
                                  ? ""
                                  : yearSelected.value,
                              style: AppTheme.text_lg(
                                      AppThemeTextStyleType.semibold)
                                  .copyWith(
                                color: GlobalColors.grey_500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const MitraDividerWidget(),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: DatePickerWidget(
                  looping: false,
                  initialDate: selectedDate.value,
                  firstDate: DateTime(1990),
                  lastDate: DateTime((DateTime.now().year) + 30),
                  dateFormat: "dd/MMMM/yyyy",
                  locale: currentLocale,
                  onChange: (DateTime newDate, _) {
                    selectedDate.value = newDate;
                    dayOfWeek.value = DateFormat('EEE', '${Get.deviceLocale}')
                        .format(selectedDate.value);
                    daySelected.value =
                        DateFormat('d').format(selectedDate.value);
                    mounthSelected.value =
                        DateFormat('MMM', '${Get.deviceLocale}')
                            .format(selectedDate.value);
                    yearSelected.value =
                        DateFormat('y').format(selectedDate.value);
                  },
                  pickerTheme:  DateTimePickerTheme(
                    backgroundColor: Colors.transparent,
                    itemTextStyle: const TextStyle(
                      color: GlobalColors.grey_900,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                    dividerColor: GlobalColors.appPrimary_600,
                  ),
                ),
              ),
              Obx(
                (() => _verifyDateAndCompareDate(hasToCompare,
                        selectedDate.value, isStartDate, compareDate)
                    ? const SizedBox()
                    : isStartDate
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'invalid_start_data'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'invalid_end_data'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24, right: 20, left: 20, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: AppButtonWidget(
                        style: AppButtonStyle.outlined,
                        child: Text(
                          'button_cancel'.tr,
                          style: AppTheme.text_md(AppThemeTextStyleType.medium)
                              .copyWith(color: GlobalColors.grey_700),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        (() => AppButtonWidget(
                              style: AppButtonStyle.contained,
                              onPressed: () {
                                if (_verifyDateAndCompareDate(
                                    hasToCompare,
                                    selectedDate.value,
                                    isStartDate,
                                    compareDate)) {
                                  newSelectedDate = selectedDate.value;
                                  Get.back();
                                }
                              },
                              disableButton: !(_verifyDateAndCompareDate(
                                  hasToCompare,
                                  selectedDate.value,
                                  isStartDate,
                                  compareDate)),
                              child: Text(
                                'button_add'.tr,
                                style: AppTheme.text_md(
                                        AppThemeTextStyleType.medium)
                                    .copyWith(color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );


  // Final do dialog
  return newSelectedDate;
}

bool _verifyDateAndCompareDate(
  bool hasToCompare,
  DateTime currentDate,
  bool isStartDate,
  DateTime? compareDate,
) {
  if (hasToCompare) {
    if (isStartDate) {
      if (compareDate != null) {
        // Esse if é referente a primeira data e ela precisa ser antes da data de comparação.
        return currentDate.isBefore(compareDate); // Antes
      } else {
        return true;
      }
    } else {
      if (compareDate != null) {
        // Esse if é referente a segunda data e ela precisa ser depois da data de comparação.
        return currentDate.isAfter(compareDate); // Depois
      } else {
        return true;
      }
    }
  } else {
    return true;
  }
}
