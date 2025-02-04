import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';


Widget filterHead(BuildContext context, FilterBarController controller) {
  return Obx(
    () => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingScale.scaleTwoAndHalf,
        vertical: SpacingScale.scaleTwo
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              controller.verifyHaveValueSelected();
              Get.back();
            },
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: GlobalColors.violet_600,
              size: 24,
            ),
          ),

          Text(
            '${controller.filterBarsList.value.name}',
            style: AppTheme.text_md(AppThemeTextStyleType.semibold),
            textAlign: TextAlign.center,
          ),
          //NOTE: verifica se tem valor selecionado para desenhar o "Limpar" com cor ou sem.

          controller.mobileScreenController.selectedScreen.value
                  .haveValueSelected.value
              ? _buildCleanWidget(context, controller)
              : _buildDissabledCleanWidget()
        ],
      ),
    ),
  );
}

Widget _buildCleanWidget(BuildContext context, FilterBarController controller) {
  return InkWell(
    onTap: () async {
      if (!controller.isApplingFilter.value) {
        await controller.cleanAllSelections();
        await controller.deleteTempFilters(
            screenId:
                controller.mobileScreenController.selectedScreen.value.id!);
        (context as Element).markNeedsBuild();
      }
      // Get.back();
    },
    child: Text(
      'clean'.tr,
      style: AppTheme.text_xs(AppThemeTextStyleType.regular)
          .copyWith(color: GlobalColors.violet_600),
    ),
  );
}

Widget _buildDissabledCleanWidget() {
  return Text(
    'clean'.tr,
    style: AppTheme.text_xs(AppThemeTextStyleType.regular)
        .copyWith(color: GlobalColors.grey_500),
  );
}
