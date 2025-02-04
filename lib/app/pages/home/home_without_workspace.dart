import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class HomeWithoutWorkspacePage extends GetView<HomeController> {
  const HomeWithoutWorkspacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: SpacingScale.scaleTwoAndHalf),
            color: Colors.white,
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/empty_image.svg',
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                Text(
                  'dont_have_workspace'.tr,
                  style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                const MitraDividerWidget(),
                const SizedBox(height: SpacingScale.scaleThree),
                _containerTextWidget(
                  title: 'already_mitra_customer'.tr,
                  subTitle: 'contact_workspace_adm'.tr,
                  buttonText: '',
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                _containerTextWidget(
                  title: 'beta_tester_version'.tr,
                  subTitle: 'beta_tester_adjust_registration'.tr,
                  buttonText: '',
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                _containerTextWidget(
                  title: 'want_teste_new_version'.tr,
                  subTitle: 'join_waitlist_early_access'.tr,
                  buttonText: 'join_waiting_list'.tr,
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                AppButtonWidget(
                  buttonColor: GlobalColors.error_600,
                  borderRadius: 8,
                  child: Text(
                    'logout'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: Colors.white), // Sem copyWith
                  ),
                  onPressed: () {
                    controller.simpleLogout();
                    // controller.simpleLogout();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerTextWidget(
      {required String title,
      required String subTitle,
      required String buttonText}) {
    return Container(
      padding: const EdgeInsets.all(SpacingScale.scaleThree),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: GlobalColors.grey_200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.text_md(AppThemeTextStyleType.semibold),
          ),
          const SizedBox(height: SpacingScale.scaleTwo),
          Text(
            subTitle,
            style: AppTheme.text_sm(AppThemeTextStyleType.regular).copyWith(
              color: GlobalColors.grey_500,
            ),
          ),
          SizedBox(height: buttonText != '' ? SpacingScale.scaleTwo : 0),
          buttonText != ''
              ? AppButtonWidget(
                  child: Text(
                    buttonText,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: Colors.white), // Sem copyWith
                  ),
                  onPressed: () {
                    controller.signToWaitList();
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
