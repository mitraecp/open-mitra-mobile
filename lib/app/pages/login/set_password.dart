import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/password_requireds_widgetd.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class SetPassowrdPage extends GetView<LoginController> {
  const SetPassowrdPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          controller.setScreensForResetPassword.value
              ? 'redefine_password'.tr
              : 'set_password'.tr,
          style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
        ),
        appLeading: Padding(
          padding: const EdgeInsets.only(left: SpacingScale.scaleOne),
          child: IconButton(
            onPressed: () {
              Get.back();
              controller.disposePasswordAndRules();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 30,
            ),
          ),
        ),
        isToAddOnTopContainer: controller.isToShowAppBarOnTopContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpacingScale.scaleTwoAndHalf),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Note: Password
            Obx(
              () => MitraInputTextField(
                inputTitle: 'password'.tr,
                inputTitleStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                    .copyWith(color: GlobalColors.grey_700),
                inputHintText: 'insert_your_password'.tr,
                inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                    .copyWith(color: GlobalColors.grey_400),
                obscureText: true,
                controller: controller.passwordController,
                showPassword: controller.showPassword.isTrue,
                inputError: controller.emailOrPasswordError.value,
                inputTextType: TextInputType.text,
                suffixIconWidget: GestureDetector(
                  onTap: () {
                    controller.togglevisibility();
                  },
                  child: Icon(
                    controller.showPassword.isFalse
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xff7B8098).withOpacity(.79),
                    size: 18,
                  ),
                ),
              ),
            ),

            controller.setScreensForResetPassword.value
                ? const SizedBox(height: SpacingScale.scaleThree)
                : const SizedBox(),

            controller.setScreensForResetPassword.value
                ? Obx(
                    () => MitraInputTextField(
                      backgroundColor: GlobalColors.grey_50,
                      inputTitle: 'password_confirmation'.tr,
                      inputTitleStyle:
                          AppTheme.text_sm(AppThemeTextStyleType.medium)
                              .copyWith(color: GlobalColors.grey_700),
                      inputHintText: 'confirm_password'.tr,
                      inputHintStyle:
                          AppTheme.text_sm(AppThemeTextStyleType.medium)
                              .copyWith(color: GlobalColors.grey_400),
                      obscureText: true,
                      controller: controller.confirmPasswordController,
                      showPassword: controller.showPassword.isTrue,
                      inputError: controller.passwordsNotMatches.value,
                      inputTextType: TextInputType.text,
                      suffixIconWidget: GestureDetector(
                        onTap: () {
                          controller.togglevisibility();
                        },
                        child: Icon(
                          controller.showPassword.isFalse
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xff7B8098).withOpacity(.79),
                          size: 18,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            // Erro no Input do codigo de verificação
            controller.setScreensForResetPassword.value
                ? Obx(
                    () => controller.passwordsNotMatches.value
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: SpacingScale.scaleHalf),
                            child: Text(
                              'password_are_not_the_same'.tr,
                              style: AppTheme.text_sm(
                                      AppThemeTextStyleType.regular)
                                  .copyWith(color: GlobalColors.error_500),
                            ),
                          )
                        : const SizedBox(),
                  )
                : const SizedBox(),

            const SizedBox(height: SpacingScale.scaleThree),

            const PasswordRequiredsWidget(),

            const SizedBox(height: SpacingScale.scaleThree),

            // Botão de continuar
            Obx(
              () => AppButtonWidget(
                style: AppButtonStyle.contained,
                disableButton: controller.setScreensForResetPassword.value
                    ? !controller.passwordAllRulesMatch.value ||
                        !controller.confirmPasswordIsEmpty.value
                    : !controller.passwordAllRulesMatch.value,
                child: Text(
                  controller.setScreensForResetPassword.value
                      ? 'redefine'.tr
                      : 'continue'.tr,
                  style: AppTheme.text_md(AppThemeTextStyleType.medium)
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  if (controller.setScreensForResetPassword.value) {
                    controller.handleClickResetPasswordButton();
                  } else {
                    controller.signUpWithEmailAndPassword();
                  }
                },
              ),
            ),

            const Spacer(),
            const Center(child: AppVersionWidget())
          ],
        ),
      ),
    );
  }
}
