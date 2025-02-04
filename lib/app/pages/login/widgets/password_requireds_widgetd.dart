import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class PasswordRequiredsWidget extends StatelessWidget {
  const PasswordRequiredsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find<LoginController>();

    return Container(
      padding: const EdgeInsets.all(SpacingScale.scaleTwo),
      decoration: BoxDecoration(
        color: GlobalColors.grey_25,
        border: Border.all(color: GlobalColors.grey_25),
        borderRadius: const BorderRadius.all(
          Radius.circular(SpacingScale.scaleOne),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: GlobalColors.grey_400,
              ),
              const SizedBox(width: SpacingScale.scaleOne),
              Text(
                'your_password_must_contain'.tr,
                style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                    .copyWith(color: GlobalColors.grey_400),
              )
            ],
          ),
          const SizedBox(height: SpacingScale.scaleOne),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: SpacingScale.scaleOne),
            child: Row(
              children: [
                passwordIconRuleForSixCharacters(controller),
                const SizedBox(width: SpacingScale.scaleOne),
                Text(
                  'at_least_6_characters'.tr,
                  style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_400),
                )
              ],
            ),
          ),
          const SizedBox(height: SpacingScale.scaleOne),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: SpacingScale.scaleOne),
            child: Row(
              children: [
                passwordIconRuleForUpperAndLowerCase(controller),
                const SizedBox(width: SpacingScale.scaleOne),
                Text(
                  'uppercase_and_lowercase_letters'.tr,
                  style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_400),
                )
              ],
            ),
          ),
          const SizedBox(height: SpacingScale.scaleOne),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: SpacingScale.scaleOne),
            child: Row(
              children: [
                passwordIconRuleNumber(controller),
                const SizedBox(width: SpacingScale.scaleOne),
                Text(
                  'numbers'.tr,
                  style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                      .copyWith(color: GlobalColors.grey_400),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordIconRuleForSixCharacters(LoginController controller) {
    return Obx(
      () => Icon(
        controller.passwordIsEmpty.value
            ? Icons.arrow_right
            : controller.passwordRuleLengthGreaterThanSix.value
                ? Icons.check
                : Icons.close,
        size: 16,
        color: controller.passwordIsEmpty.value
            ? GlobalColors.grey_500
            : controller.passwordRuleLengthGreaterThanSix.value
                ? GlobalColors.success_500
                : GlobalColors.error_500,
      ),
    );
  }

  Widget passwordIconRuleForUpperAndLowerCase(LoginController controller) {
    return Obx(
      () => Icon(
        controller.passwordIsEmpty.value
            ? Icons.arrow_right
            : controller.passwordRuleForUpperAndLowerCase.value
                ? Icons.check
                : Icons.close,
        size: 16,
        color: controller.passwordIsEmpty.value
            ? GlobalColors.grey_500
            : controller.passwordRuleForUpperAndLowerCase.value
                ? GlobalColors.success_500
                : GlobalColors.error_500,
      ),
    );
  }

  Widget passwordIconRuleNumber(LoginController controller) {
    return Obx(
      () => Icon(
        controller.passwordIsEmpty.value
            ? Icons.arrow_right
            : controller.passwordRuleNumber.value
                ? Icons.check
                : Icons.close,
        size: 16,
        color: controller.passwordIsEmpty.value
            ? GlobalColors.grey_500
            : controller.passwordRuleNumber.value
                ? GlobalColors.success_500
                : GlobalColors.error_500,
      ),
    );
  }
}
