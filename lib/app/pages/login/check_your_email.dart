import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/login_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_button_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/app_version_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_app_bar_widget.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_input_text_field.dart';
import 'package:open_mitra_mobile/app/theme/app_theme.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';


class CheckYourEmailPage extends GetView<LoginController> {
  const CheckYourEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.codeSent.value = true;
    controller.startSendCheckEmailCodeTimer();
    return Scaffold(
      appBar: MitraAppBar(
        appTitle: Text(
          'check_your_email'.tr,
          style: AppTheme.text_lg(AppThemeTextStyleType.semibold),
        ),
        appLeading: Padding(
          padding: const EdgeInsets.only(left: SpacingScale.scaleOneAndHalf),
          child: IconButton(
            onPressed: () {
              Get.back();
              controller.disposeCheckEmail();
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
          padding: const EdgeInsets.all(
            SpacingScale.scaleTwoAndHalf,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header texts
              Text(
                'we_send_virification_code'.tr,
                style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                    .copyWith(color: GlobalColors.grey_500),
                textAlign: TextAlign.center,
              ),
              Text(
                controller.emailController.text,
                style: AppTheme.text_sm(AppThemeTextStyleType.regular).copyWith(
                    color: GlobalColors.grey_500, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: SpacingScale.scaleThree),

              // Input do codigo de verificação
              Obx(
                () => MitraInputTextField(
                  obscureText: false,
                  controller: controller.checkEmailController,
                  inputTitle: 'verification_code'.tr,
                  inputTitleStyle:
                      AppTheme.text_sm(AppThemeTextStyleType.medium)
                          .copyWith(color: GlobalColors.grey_700),
                  inputHintText: 'insert_verification_code'.tr,
                  inputHintStyle: AppTheme.text_sm(AppThemeTextStyleType.medium)
                      .copyWith(color: GlobalColors.grey_400),
                  showPassword: false,
                  inputError: controller.codeError.value,
                  inputTextType: TextInputType.number,
                  suffixIconWidget: controller.codeError.value
                      ? const Icon(
                          Icons.error_outline,
                          color: GlobalColors.error_500,
                          size: 16,
                        )
                      : const SizedBox(),
                ),
              ),

              // Erro no Input do codigo de verificação
              Obx(
                () => controller.codeError.value
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: SpacingScale.scaleHalf),
                        child: Text(
                          'incorrect_code'.tr,
                          style: AppTheme.text_sm(AppThemeTextStyleType.regular)
                              .copyWith(color: GlobalColors.error_500),
                        ),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: SpacingScale.scaleThree),

              // Botao de verificar codigo
              Obx(
                () => AppButtonWidget(
                  style: AppButtonStyle.contained,
                  disableButton: controller.checkEmailIsEmpty.value,
                  loading: controller.loading.value,
                  child: Text(
                    'check_email'.tr,
                    style: AppTheme.text_md(AppThemeTextStyleType.medium)
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    if (controller.setScreensForResetPassword.value) {
                      controller.sendCheckEmailCodeOfResetPassword();
                    } else {
                      controller.sendCheckEmailCode();
                    }
                  },
                ),
              ),

              const SizedBox(height: SpacingScale.scaleThree),

              // Texto de reenviar codigo
              Obx(
                () => controller.codeSent.value
                    ? InkWell(
                        onTap: () {
                          controller.sendCheckEmailCodeTimer.value == 0
                              ? controller.resendCheckEmailCode()
                              : null;
                        },
                        child: RichText(
                          text: controller.sendCheckEmailCodeTimer.value != 0
                              ? _buildTextSpanWithResendTimer()
                              : _buildTextSpanWithResendText(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox(),
              ),
              const Spacer(),
              const Center(child: AppVersionWidget())
            ],
          )),
    );
  }

  TextSpan _buildTextSpanWithResendTimer() {
    return TextSpan(
      text: 'didnt_receive_code_part_1'.tr,
      style: AppTheme.text_sm(AppThemeTextStyleType.regular)
          .copyWith(color: GlobalColors.grey_500),
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: 'didnt_receive_code_part_2'.tr,
          style: AppTheme.text_sm(AppThemeTextStyleType.medium)
              .copyWith(color: GlobalColors.grey_500),
        ),
        const TextSpan(text: ' '),
        TextSpan(
          text: '${controller.sendCheckEmailCodeTimer.value}',
          style: AppTheme.text_sm(AppThemeTextStyleType.medium)
              .copyWith(color: GlobalColors.grey_500),
        ),
        const TextSpan(
          text: ' ',
        ),
        TextSpan(
          text: 'didnt_receive_code_part_3'.tr,
          style: AppTheme.text_sm(AppThemeTextStyleType.medium)
              .copyWith(color: GlobalColors.grey_500),
        ),
      ],
    );
  }

  TextSpan _buildTextSpanWithResendText() {
    return TextSpan(
      text: 'didnt_receive_code_part_1'.tr,
      style: AppTheme.text_sm(AppThemeTextStyleType.regular)
          .copyWith(color: GlobalColors.grey_500),
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: 'resend'.tr,
          style: AppTheme.text_sm(AppThemeTextStyleType.medium)
              .copyWith(color: GlobalColors.violet_600),
        ),
      ],
    );
  }
}
