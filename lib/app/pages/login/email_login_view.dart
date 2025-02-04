import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class EmailLoginView extends GetView<LoginController> {
  const EmailLoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'continue_with_email'.tr,
          style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
        ),
        appLeading: Padding(
          padding: const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
          child: IconButton(
            onPressed: () {
              Get.back();
              controller.clearInputFields();
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
            //Note: Email
            Obx(
              () => MitraInputTextField(
                obscureText: false,
                controller: controller.emailController,
                inputTitle: 'E-mail',
                inputTitleStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                    .copyWith(color: GlobalColors.grey_700),
                inputHintText: 'insert_your_email'.tr,
                inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                    .copyWith(color: GlobalColors.grey_400),
                showPassword: false,
                inputTextType: TextInputType.emailAddress,
                inputError: controller.emailOrPasswordError.value,
              ),
            ),

            const SizedBox(height: SpacingScale.scaleThree),

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

            const SizedBox(height: SpacingScale.scaleThree),

            // Esqueceu a senha
            InkWell(
              onTap: () {
                Get.toNamed(AppPages.FORGOT_PASSWORD);
              },
              child: Text(
                'forgot_password'.tr,
                style: AppTheme.text_sm(AppThemeTextStyleType.medium).copyWith(
                  color: GlobalColors.violet_600,
                ),
              ),
            ),

            const SizedBox(height: SpacingScale.scaleThree),

            // Botão de continuar
            Obx(
              () => AppButtonWidget(
                style: AppButtonStyle.contained,
                disableButton: controller.completedFields.value,
                child: Text(
                  'continue'.tr,
                  style: AppTheme.text_md(AppThemeTextStyleType.medium)
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  controller.loginWithEmail();
                },
              ),
            ),

            const SizedBox(height: SpacingScale.scaleThree),

            // Texto de erro.
            Center(
              child: Obx(
                () {
                  return controller.emailOrPasswordError.value
                      ? Text(
                          'incorrect_username_password'.tr,
                          style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                              .copyWith(
                            color: GlobalColors.error_500,
                          ),
                        )
                      : const SizedBox();
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
