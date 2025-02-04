import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/apple_login_button.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/google_login_button.dart';
import 'package:open_mitra_mobile/app/pages/login/widgets/microsoft_login_button.dart';
import 'package:open_mitra_mobile/app/routes/app_pages.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class RegisterView extends GetView<LoginController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'back'.tr,
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
        padding: const EdgeInsets.only(
            left: SpacingScale.scaleTwoAndHalf,
            bottom: SpacingScale.scaleTwoAndHalf,
            right: SpacingScale.scaleTwoAndHalf,
            top: SpacingScale.scaleTwo),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'create_account_email'.tr,
                style: AppTheme.text_md(AppThemeTextStyleType.semibold),
              ),
            ),

            const SizedBox(height: SpacingScale.scaleThree),
            //Note: Email
            MitraInputTextField(
              obscureText: false,
              controller: controller.emailController,
              inputTitle: 'E-mail',
              inputTitleStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_700),
              inputHintText: 'insert_your_email'.tr,
              inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                  .copyWith(color: GlobalColors.grey_400),
              inputTextType: TextInputType.emailAddress,
              showPassword: false,
              inputError: false,
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
                  Get.toNamed(AppPages.CREATE_USER);
                },
              ),
            ),

            const SizedBox(height: SpacingScale.scaleFive),

            const MitraDividerWidget(),

            const SizedBox(height: SpacingScale.scaleFive),

            Center(
              child: Text(
                'or_continue_with'.tr,
                style: AppTheme.text_md(AppThemeTextStyleType.semibold),
              ),
            ),

            const SizedBox(height: SpacingScale.scaleThree),

            const AppleLoginButton(),
            const SizedBox(height: SpacingScale.scaleThree),
            GoogleLoginButton(),
            const SizedBox(height: SpacingScale.scaleThree),
            const MicrosoftLoginButton(),

            const Spacer(),

            const Center(child: AppVersionWidget())
          ],
        ),
      ),
    );
  }
}
