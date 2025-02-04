import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class AccountVerifiedPage extends GetView<LoginController> {
  const AccountVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: GlobalColors.success_50,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlobalColors.success_100,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: GlobalColors.success_500,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                Text(
                  controller.setScreensForResetPassword.value
                      ? 'password_reset'.tr
                      : 'verification_complete'.tr,
                  textAlign: TextAlign.center,
                  style: AppTheme.display_xs(AppThemeTextStyleType.semibold),
                ),
                const SizedBox(height: SpacingScale.scaleOne),
                Text(
                  controller.setScreensForResetPassword.value
                      ? 'password_succesfully_reset'.tr
                      : 'account_has_been_verified'.tr,
                  textAlign: TextAlign.center,
                  style: AppTheme.text_md(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_500),
                ),
                const SizedBox(height: SpacingScale.scaleThree),
                AppButtonWidget(
                  style: AppButtonStyle.contained,
                  child: Text(
                    'continue'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () async {
                    controller.loginWithEmail();
                  },
                ),
                const Spacer(),
                const Center(child: AppVersionWidget())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
