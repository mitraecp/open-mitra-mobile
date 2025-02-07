import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/menu_page_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_snackbar.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/pages/menu/widgets/body_sent_report_error_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MenuReportErrorView extends GetView<MenuPageController> {
  const MenuReportErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarSentReportError(),
      body: Obx(
        (() => controller.sendingEmail.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BodySentReportError(controller: controller)),
      ),
      // bottomNavigationBar: MitraBottomNavBarWidget(),
    );
  }

  PreferredSizeWidget _buildAppBarSentReportError() {
    return MitraAppBar(
      appTitle: Text(
        'report_error'.tr,
        style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
      ),
      appLeading: Padding(
        padding: const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
        child: IconButton(
          onPressed: () {
            controller.cleanControllers();
            Get.back();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 30,
          ),
        ),
      ),
      isToAddOnTopContainer: controller.isToShowAppBarOnTopContainer,
      appAction: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: SpacingScale.scaleOneAndHalf),
            child: TextButton(
              onPressed: () async {
                !controller.isEditingReportError.value
                    ? AppSnackBar().concluded('', 'fill_in_to_report'.tr)
                    : await controller.sentReportError()
                        ? {
                            controller.sendingEmail.value = false,
                            Get.back(),
                            AppSnackBar().concluded('', 'feedback_sent'.tr)
                          }
                        : Get.defaultDialog(
                            title: "error".tr,
                            content: Text(
                              'error_email_body'.tr,
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ).then(
                            (value) => controller.sendingEmail.value = false);
                // WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                // Get.back();
              },
              child: Text('sent'.tr,
                  style: !controller.isEditingReportError.value
                      ? AppTheme.text_sm(AppThemeTextStyleType.regular)
                          .copyWith(color: GlobalColors.grey_400)
                      : AppTheme.text_sm(AppThemeTextStyleType.semibold)
                          .copyWith(color: GlobalColors.appPrimary_600)),
            ),
          ),
        ),
      ],
    );
  }
}
