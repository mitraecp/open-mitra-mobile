import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class ForgotPasswordView extends GetView<LoginController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'forgot_the_password'.tr,
          style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
        ),
        appLeading: Padding(
          padding: const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
          child: IconButton(
            onPressed: () {
              controller.setScreensForResetPassword.value = false;
              Get.back();
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
            Text(
              'forgot_the_password_body'.tr,
              style: AppTheme.text_sm(
                AppThemeTextStyleType.regular,
              ).copyWith(color: GlobalColors.grey_500),
            ),
            const SizedBox(height: SpacingScale.scaleThree),
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

            // Botão de continuar
            Obx(
              () => AppButtonWidget(
                style: AppButtonStyle.contained,
                disableButton: controller.emailIsEmpty.value,
                child: Text(
                  'continue'.tr,
                  style: AppTheme.text_md(AppThemeTextStyleType.medium)
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  controller.resetPassword();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
