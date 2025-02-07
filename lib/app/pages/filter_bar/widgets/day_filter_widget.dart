import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_date_picker.dart';
import 'package:open_mitra_mobile/app/helpers/date_time__picker_device_locale.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

Widget buildDayFilter(BuildContext context, FilterBarController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'period'.tr,
          style: AppTheme.text_sm(AppThemeTextStyleType.medium)
              .copyWith(color: GlobalColors.grey_700),
        ),
        const SizedBox(height: SpacingScale.scaleOne),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _builDataPickerButton(
              onTap: () async {
                await _getDate(
                    context: context,
                    isStartDate: true,
                    controller: controller);
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                //NOTE: Uso esse delayed para esperar o Get.back fechar o dialog para abrir o outro.
                await Future.delayed(const Duration(milliseconds: 300));
                (context as Element).markNeedsBuild();

                //NOTE: Após preencher a data inicial, abrir automaticamente a data final.
                if (controller.startSelectedDateModel.value.dateString !=
                        null &&
                    controller.endSelectedDateModel.value.dateString == null) {
                  // ignore: use_build_context_synchronously
                  await _getDate(
                      // ignore: use_build_context_synchronously
                      context: context,
                      isStartDate: false,
                      controller: controller);
                  // ignore: unnecessary_cast
                  (context as Element).markNeedsBuild();
                }
                if (controller.startSelectedDateModel.value.dateString !=
                    null) {
                  controller.mobileScreenController.selectedScreen.value
                      .haveValueSelected.value = true;
                  controller.haveChange = true;
                }
              },
              hintText:
                  controller.startSelectedDateModel.value.dateString == null
                      ? 'start_date'.tr
                      : controller.startSelectedDateModel.value.dateString!,
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: controller.startSelectedDateModel.value.dateString !=
                            null
                        ? Colors.black
                        : const Color(0xff6A6A82).withOpacity(.5),
                    fontSize: 16,
                  ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: SpacingScale.scaleOne),
              child: Icon(
                Icons.arrow_forward,
                size: 20,
                color: GlobalColors.grey_400,
              ),
            ),
            _builDataPickerButton(
              onTap: () async {
                await _getDate(
                    context: context,
                    isStartDate: false,
                    controller: controller);
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

                if (controller.endSelectedDateModel.value.dateString != null) {
                  controller.mobileScreenController.selectedScreen.value
                      .haveValueSelected.value = true;
                  controller.haveChange = true;
                }
                (context as Element).markNeedsBuild();
              },
              hintText: controller.endSelectedDateModel.value.dateString == null
                  ? 'end_date'.tr
                  : controller.endSelectedDateModel.value.dateString!,
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        controller.endSelectedDateModel.value.dateString != null
                            ? Colors.black
                            : const Color(0xff6A6A82).withOpacity(.5),
                    fontSize: 16,
                  ),
            )
          ],
        )
      ],
    ),
  );
}

Widget _builDataPickerButton({
  required void Function() onTap,
  required String hintText,
  required TextStyle hintStyle,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SpacingScale.custom(14),
          vertical: SpacingScale.custom(10),
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: GlobalColors.grey_300)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: GlobalColors.appPrimary_600,
            ),
            const SizedBox(width: SpacingScale.scaleOne),
            Text(
              hintText == '' ? '2022-12-01' : hintText,
              style: AppTheme.text_md(AppThemeTextStyleType.regular).copyWith(
                color: GlobalColors.grey_500,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

_getDate(
    {required BuildContext context,
    required bool isStartDate,
    required FilterBarController controller}) async {
  var data = '';

  var dateTimeNow = DateTime.now();
  //NOTE: SelectedDate vai receber a data selecionavel, se ja tiver vindo alguma data do banco, preciso atualizar.
  var selectedDate = (isStartDate
          ? controller.startSelectedDateModel.value.dateTimeFormat != null
              ? controller.startSelectedDateModel.value.dateTimeFormat!
              : dateTimeNow
          : controller.endSelectedDateModel.value.dateTimeFormat != null
              ? controller.endSelectedDateModel.value.dateTimeFormat!
              : DateTime(
                  dateTimeNow.year, dateTimeNow.month, dateTimeNow.day + 1))
      .obs;

  await showMitraDatePicker(
    context: context,
    currentLocale: helperVerifyDeviceLocale(),
    currentDate: selectedDate.value,
    isStartDate: isStartDate,
    hasToCompare: true,
    compareDate: isStartDate
        ? controller.endSelectedDateModel.value.dateTimeFormat
        : controller.startSelectedDateModel.value.dateTimeFormat,
  ).then((newSelectedDate) {
    if (newSelectedDate != null) {
      //NOTE: Formato para guardar no model selecionado.
      var a = DateFormat('yyyyMMdd');
      var dateSelect = a.format(newSelectedDate).toString();

      //NOTE: Formato para mostrar ao usuario.
      var f = DateFormat('dd/MM/yyyy');
      data = f.format(newSelectedDate).toString();

      //NOTE: true é para data inicial, e falso para data final;
      if (isStartDate) {
        controller.startSelectedDateModel.value.dateString = data;
        controller.startSelectedDateModel.value.dateValue = dateSelect;
        controller.startSelectedDateModel.value.dateTimeFormat =
            newSelectedDate;
        controller.apllyDayFilter();
      } else {
        controller.endSelectedDateModel.value.dateString = data;
        controller.endSelectedDateModel.value.dateValue = dateSelect;
        controller.endSelectedDateModel.value.dateTimeFormat = newSelectedDate;
        controller.apllyDayFilter();
      }
    }
  });
}
