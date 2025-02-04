import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

Widget filterBottom(FilterBarController controller) {
  return Obx(
    () => !controller.loading.isTrue
        ? Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SpacingScale.scaleTwoAndHalf),
            child: AppButtonWidget(
              style: AppButtonStyle.contained,
              child: Text(
                'view_results'.tr,
                style: AppTheme.text_md(AppThemeTextStyleType.medium)
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                controller.verifyHaveValueSelected();
                Get.back();
              },
            ),
          )
        : Container(),
  );
}
