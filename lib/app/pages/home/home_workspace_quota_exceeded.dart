import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/home_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class HomeWorkspaceQuotaExceededPage extends GetView<HomeController> {
  const HomeWorkspaceQuotaExceededPage({Key? key}) : super(key: key);

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
                  'Ops! Você atingiu o limite do plano!'.tr,
                  style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                const MitraDividerWidget(),
                const SizedBox(height: SpacingScale.scaleThree),
                Text(
                  'Acesse pelo desktop e navegue ate as configurações de membros do seu workspace para revisar seu plano.'
                      .tr,
                  style:
                      AppTheme.text_md(AppThemeTextStyleType.regular).copyWith(
                    color: GlobalColors.grey_500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SpacingScale.scaleThree),
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
}
